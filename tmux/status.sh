set -e

cd /Users/mike/personal_projects/piper

dart run --define=AZURE_TOKEN=$AZURE_TOKEN cli/bin/piper_cli.dart read -f local/use_config.yaml -l line
# echo "$pipelines T:$(date +'%I:%M')"
