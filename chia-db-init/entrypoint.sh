#!/bin/sh
set -e

NETWORK="${NETWORK:-mainnet}"
S3_BUCKET="${S3_BUCKET:-chia-blockchain-sqlite-backups}"
AWS_REGION="${AWS_REGION:-us-west-2}"
MIN_HEIGHT="${MIN_HEIGHT:-2000}"

if [ -z "$CHIA_ROOT" ]; then
    echo "ERROR: CHIA_ROOT is not set"
    exit 1
fi

DB_DIR="${CHIA_ROOT}/db"
DB_FILE="blockchain_v2_${NETWORK}.sqlite"
DB_PATH="${DB_DIR}/${DB_FILE}"
S3_PREFIX="s3://${S3_BUCKET}/${NETWORK}"

if [ "$NETWORK" = "mainnet" ]; then
    CACHE_SUFFIX=""
else
    CACHE_SUFFIX="-${NETWORK}"
fi

get_local_height() {
    local_height=$(sqlite3 "$DB_PATH" "SELECT MAX(height) FROM full_blocks;" 2>/dev/null || echo "")

    if [ -z "$local_height" ]; then
        echo "0"
        return
    fi

    echo "$local_height"
}

delete_db_files() {
    echo "Removing existing DB and cache files..."
    rm -f "$DB_PATH" "${DB_PATH}-shm" "${DB_PATH}-wal"
    rm -f "${DB_DIR}/height-to-hash" "${DB_DIR}/height-to-hash${CACHE_SUFFIX}"
    rm -f "${DB_DIR}/sub-epoch-summaries" "${DB_DIR}/sub-epoch-summaries${CACHE_SUFFIX}"
}

download_db_from_s3() {
    mkdir -p "$DB_DIR"

    echo "Downloading blockchain DB from S3..."
    if aws s3api head-object --bucket "$S3_BUCKET" --key "${NETWORK}/${DB_FILE}.gz" --region "$AWS_REGION" >/dev/null 2>&1; then
        echo "Found gzipped DB, downloading ${DB_FILE}.gz..."
        aws s3 cp "${S3_PREFIX}/${DB_FILE}.gz" "${DB_PATH}.gz" --region "$AWS_REGION"
        echo "Decompressing ${DB_FILE}.gz..."
        gunzip -f "${DB_PATH}.gz"
    else
        echo "No gzipped DB found, downloading uncompressed ${DB_FILE}..."
        aws s3 cp "${S3_PREFIX}/${DB_FILE}" "$DB_PATH" --region "$AWS_REGION"
    fi
}

has_cache_file() {
    # Check for both suffixed and unsuffixed variants
    [ -f "${DB_DIR}/${1}${CACHE_SUFFIX}" ] || [ -f "${DB_DIR}/${1}" ]
}

download_cache_files() {
    mkdir -p "$DB_DIR"

    if ! has_cache_file "height-to-hash"; then
        echo "Downloading height-to-hash to ${DB_DIR}/height-to-hash${CACHE_SUFFIX}..."
        aws s3 cp "${S3_PREFIX}/height-to-hash" "${DB_DIR}/height-to-hash${CACHE_SUFFIX}" --region "$AWS_REGION" || \
            echo "WARNING: Failed to download height-to-hash, node will regenerate it"
    fi

    if ! has_cache_file "sub-epoch-summaries"; then
        echo "Downloading sub-epoch-summaries to ${DB_DIR}/sub-epoch-summaries${CACHE_SUFFIX}..."
        aws s3 cp "${S3_PREFIX}/sub-epoch-summaries" "${DB_DIR}/sub-epoch-summaries${CACHE_SUFFIX}" --region "$AWS_REGION" || \
            echo "WARNING: Failed to download sub-epoch-summaries, node will regenerate it"
    fi
}

echo "=== Chia DB Init ==="
echo "Network:     ${NETWORK}"
echo "CHIA_ROOT:   ${CHIA_ROOT}"
echo "DB path:     ${DB_PATH}"
echo "S3 bucket:   ${S3_BUCKET}"
echo "AWS region:  ${AWS_REGION}"
echo "Min height:  ${MIN_HEIGHT}"
echo ""

if [ -f "$DB_PATH" ]; then
    echo "Found existing DB at ${DB_PATH}"

    local_height=$(get_local_height)
    echo "Local block height: ${local_height}"

    if [ "$local_height" -ge "$MIN_HEIGHT" ]; then
        echo "Local DB has sufficient blocks (${local_height} >= ${MIN_HEIGHT})"
        download_cache_files
        echo "Done"
        exit 0
    fi

    echo "Local height ${local_height} is below minimum ${MIN_HEIGHT}, re-downloading..."
    delete_db_files
else
    echo "No existing DB found at ${DB_PATH}"
fi

download_db_from_s3
download_cache_files
echo "Done"
