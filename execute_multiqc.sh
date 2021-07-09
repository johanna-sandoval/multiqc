#!/usr/bin/env bash

# The following arguments are required (and in order)
# - the out suffix
# - the output directory
# - the input files (path to directories with metric files)
# - the remaining options

set -eo pipefail

# report
multiqc_report() {
    # Arguments:
    # - out suffix
    # - output directory
    # - input files
    # - remaining options

    # Out suffix
    local out_suffix=$1; shift

    # The output directory
    local output_dir=$1; shift

    # Output file
    mkdir -p "$output_dir"
    if [[ "$output_dir" != "" ]]; then
        output_tar="$output_dir"_tar
    fi
    mkdir -p "$output_tar"

    # Splitting the input files
    local input_list
    local input_args=()
    IFS=, read -r -a input_list <<< "$@"
    for itar in "${input_list[@]}"; do
        input_args+=("$itar")
    done

    # Unarchive tar inputs to tar directory
    echo "Unarchiving tar files ...\n" | \
    (tee ./multiqc_report.log >&2)

    #  Loop on input files
    for itar in "${input_args[@]}";
    do
        tar -xf "$itar" -C "$output_tar" \
        2> >(tee -a ./multiqc_report.log >&2)
    done

    # The command
    echo multiqc -f --config /opt/multiqc-env/multiqc_config_plots.yaml \
    -n "$output_dir"/"$out_suffix" \
    -o "$output_dir" \
    "$output_tar" \
    2> >(tee -a ./multiqc_report.log >&2)

    multiqc -f --config /opt/multiqc-env/multiqc_config_plots.yaml \
    -n "$output_dir"/"$out_suffix" \
    -o "$output_dir" \
    "$output_tar" \
    2> >(tee -a ./multiqc_report.log >&2)

}
export -f multiqc_report

main() {

    # The suffix
    local suffix=$1; shift

    multiqc_report "$suffix" "$@"
}

main "$@"
