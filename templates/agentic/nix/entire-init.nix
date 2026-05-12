{ pkgs, entire, entireConfig }:
let
  checkpointRemote = entireConfig.checkpointRemote or null;
  writeCheckpointConfig =
    if checkpointRemote == null then
      ""
    else
      let
        settingsJson = builtins.toJSON {
          enabled = true;
          telemetry = false;
          strategy_options = {
            checkpoint_remote = checkpointRemote;
          };
        };
      in
      ''
        mkdir -p .entire
        cat > .entire/settings.json <<'EOF'
        ${settingsJson}
        EOF
      '';
  agentsArray = builtins.concatStringsSep "\n" (map (agent: ''"${agent}"'') entireConfig.agents);
in
pkgs.writeShellApplication {
  name = "entire-init";
  text = ''
    set -eu

    ${writeCheckpointConfig}

    agents=(
      ${agentsArray}
    )

    ${pkgs.lib.getExe entire} enable --project --agent "''${agents[0]}"

    for agent in "''${agents[@]:1}"; do
      ${pkgs.lib.getExe entire} agent add "$agent"
    done
  '';
}
