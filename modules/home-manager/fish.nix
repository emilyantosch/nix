{ ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      vi = "nvim";
      em = "emacs -nw";
      ll = "eza -1 -l";
      yz = "yazi";

      # Nix Aliases
      nd = "sudo nixos-rebuild switch --upgrade --flake /home/emmi/.config/nixos/#default";
      ne = "sudo darwin-rebuild switch --flake ~/.config/nix/#emmiMBP";
      na = "sudo darwin-rebuild switch --flake ~/.config/nix/#emilyantoschMBP";

      # Git Aliases
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gf = "git fetch";
      gp = "git pull";
      gP = "git push";
      gb = "git branch";
      gC = "git checkout";
      gm = "git merge";
      gr = "git rebase";
      gl = ''git log --graph --decorate --oneline --pretty=format:"%cn committed %h on %cd"'';

      ## gh binding
      hc = "gh pr create --title";
      hv = "gh pr view --web";
      hV = "gh repo view --web";
      hr = "gh workflow run";
      hl = "gh run list";

      ca = "aws-sso exec -p ai-coding.tools -- claude";
      cA = "aws-sso exec -p ai-coding.tools -- claude --continue";
      cl = "claude";
      cc = "claude --continue";

      va = "aws-sso exec -p ai-coding.tools -- nvim";

      po = "pi --provider amazon-bedrock --model eu.anthropic.claude-opus-4-6-v1";

      # Jira
      jl = ''jira issue list --component "Fleet Optimization" --status "~Closed"'';
      jc = ''jira issue create --component "Fleet Optimization" --status "Selected"'';

      # Kubernetes
      ku = "kubectl";
      kdev = "MOIA_ENV=dev MOIA_ENVIRONMENT=dev KUBECONFIG=/Users/emilylucia.antosch/.kube/moia-base-dev:/Users/emilylucia.antosch/.kube/moia-dev fish";
      kint = "MOIA_ENV=int MOIA_ENVIRONMENT=int KUBECONFIG=/Users/emilylucia.antosch/.kube/moia-base-int:/Users/emilylucia.antosch/.kube/moia-int fish";
      kprd = "MOIA_ENV=prd MOIA_ENVIRONMENT=prd KUBECONFIG=/Users/emilylucia.antosch/.kube/moia-base-prd:/Users/emilylucia.antosch/.kube/moia-prd fish";
    };
    interactiveShellInit = ''
          export MOIA_USERNAME=emilylucia.antosch
          export EDITOR=nvim
          export PATH=$PATH:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:/bin:/sbin:/usr/sbin:/usr/local/bin:/Users/emilylucia.antosch/.cargo/bin:/Users/emilylucia.antosch/.deno/bin:/Users/emilylucia.antosch/.local/bin:/opt/homebrew/bin:/run/wrappers/bin:/usr/bin:/run/current-system/sw/bin:/Applications/Obsidian.app/Contents/MacOS
          export CARGO_NET_GIT_FETCH_WITH_CLI=true
          export AWS_REGION=eu-central-1

          # config.fish
          if test -z (pgrep ssh-agent | string collect)
            eval (ssh-agent -c)
            set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
            set -Ux SSH_AGENT_PID $SSH_AGENT_PID
            set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
          end
          ssh-add ~/.ssh/github

          abbr --add hr gh workflow run deploy-app.yaml -f environment=dev --ref $(git branch --show-current) -f application=matchmaker

          starship init fish | source
          atuin init fish | source
          mise activate fish | source
          zoxide init fish | source
      # fish completion for sesh                                 -*- shell-script -*-

      function __sesh_debug
          set -l file "$BASH_COMP_DEBUG_FILE"
          if test -n "$file"
              echo "$argv" >> $file
          end
      end

      function __sesh_perform_completion
          __sesh_debug "Starting __sesh_perform_completion"

          # Extract all args except the last one
          set -l args (commandline -opc)
          # Extract the last arg and escape it in case it is a space
          set -l lastArg (string escape -- (commandline -ct))

          __sesh_debug "args: $args"
          __sesh_debug "last arg: $lastArg"

          # Disable ActiveHelp which is not supported for fish shell
          set -l requestComp "SESH_ACTIVE_HELP=0 $args[1] __complete $args[2..-1] $lastArg"

          __sesh_debug "Calling $requestComp"
          set -l results (eval $requestComp 2> /dev/null)

          # Some programs may output extra empty lines after the directive.
          # Let's ignore them or else it will break completion.
          # Ref: https://github.com/spf13/cobra/issues/1279
          for line in $results[-1..1]
              if test (string trim -- $line) = ""
                  # Found an empty line, remove it
                  set results $results[1..-2]
              else
                  # Found non-empty line, we have our proper output
                  break
              end
          end

          set -l comps $results[1..-2]
          set -l directiveLine $results[-1]

          # For Fish, when completing a flag with an = (e.g., <program> -n=<TAB>)
          # completions must be prefixed with the flag
          set -l flagPrefix (string match -r -- '-.*=' "$lastArg")

          __sesh_debug "Comps: $comps"
          __sesh_debug "DirectiveLine: $directiveLine"
          __sesh_debug "flagPrefix: $flagPrefix"

          for comp in $comps
              printf "%s%s\n" "$flagPrefix" "$comp"
          end

          printf "%s\n" "$directiveLine"
      end

      # this function limits calls to __sesh_perform_completion, by caching the result behind $__sesh_perform_completion_once_result
      function __sesh_perform_completion_once
          __sesh_debug "Starting __sesh_perform_completion_once"

          if test -n "$__sesh_perform_completion_once_result"
              __sesh_debug "Seems like a valid result already exists, skipping __sesh_perform_completion"
              return 0
          end

          set --global __sesh_perform_completion_once_result (__sesh_perform_completion)
          if test -z "$__sesh_perform_completion_once_result"
              __sesh_debug "No completions, probably due to a failure"
              return 1
          end

          __sesh_debug "Performed completions and set __sesh_perform_completion_once_result"
          return 0
      end

      # this function is used to clear the $__sesh_perform_completion_once_result variable after completions are run
      function __sesh_clear_perform_completion_once_result
          __sesh_debug ""
          __sesh_debug "========= clearing previously set __sesh_perform_completion_once_result variable =========="
          set --erase __sesh_perform_completion_once_result
          __sesh_debug "Successfully erased the variable __sesh_perform_completion_once_result"
      end

      function __sesh_requires_order_preservation
          __sesh_debug ""
          __sesh_debug "========= checking if order preservation is required =========="

          __sesh_perform_completion_once
          if test -z "$__sesh_perform_completion_once_result"
              __sesh_debug "Error determining if order preservation is required"
              return 1
          end

          set -l directive (string sub --start 2 $__sesh_perform_completion_once_result[-1])
          __sesh_debug "Directive is: $directive"

          set -l shellCompDirectiveKeepOrder 32
          set -l keeporder (math (math --scale 0 $directive / $shellCompDirectiveKeepOrder) % 2)
          __sesh_debug "Keeporder is: $keeporder"

          if test $keeporder -ne 0
              __sesh_debug "This does require order preservation"
              return 0
          end

          __sesh_debug "This doesn't require order preservation"
          return 1
      end


      # This function does two things:
      # - Obtain the completions and store them in the global __sesh_comp_results
      # - Return false if file completion should be performed
      function __sesh_prepare_completions
          __sesh_debug ""
          __sesh_debug "========= starting completion logic =========="

          # Start fresh
          set --erase __sesh_comp_results

          __sesh_perform_completion_once
          __sesh_debug "Completion results: $__sesh_perform_completion_once_result"

          if test -z "$__sesh_perform_completion_once_result"
              __sesh_debug "No completion, probably due to a failure"
              # Might as well do file completion, in case it helps
              return 1
          end

          set -l directive (string sub --start 2 $__sesh_perform_completion_once_result[-1])
          set --global __sesh_comp_results $__sesh_perform_completion_once_result[1..-2]

          __sesh_debug "Completions are: $__sesh_comp_results"
          __sesh_debug "Directive is: $directive"

          set -l shellCompDirectiveError 1
          set -l shellCompDirectiveNoSpace 2
          set -l shellCompDirectiveNoFileComp 4
          set -l shellCompDirectiveFilterFileExt 8
          set -l shellCompDirectiveFilterDirs 16

          if test -z "$directive"
              set directive 0
          end

          set -l compErr (math (math --scale 0 $directive / $shellCompDirectiveError) % 2)
          if test $compErr -eq 1
              __sesh_debug "Received error directive: aborting."
              # Might as well do file completion, in case it helps
              return 1
          end

          set -l filefilter (math (math --scale 0 $directive / $shellCompDirectiveFilterFileExt) % 2)
          set -l dirfilter (math (math --scale 0 $directive / $shellCompDirectiveFilterDirs) % 2)
          if test $filefilter -eq 1; or test $dirfilter -eq 1
              __sesh_debug "File extension filtering or directory filtering not supported"
              # Do full file completion instead
              return 1
          end

          set -l nospace (math (math --scale 0 $directive / $shellCompDirectiveNoSpace) % 2)
          set -l nofiles (math (math --scale 0 $directive / $shellCompDirectiveNoFileComp) % 2)

          __sesh_debug "nospace: $nospace, nofiles: $nofiles"

          # If we want to prevent a space, or if file completion is NOT disabled,
          # we need to count the number of valid completions.
          # To do so, we will filter on prefix as the completions we have received
          # may not already be filtered so as to allow fish to match on different
          # criteria than the prefix.
          if test $nospace -ne 0; or test $nofiles -eq 0
              set -l prefix (commandline -t | string escape --style=regex)
              __sesh_debug "prefix: $prefix"

              set -l completions (string match -r -- "^$prefix.*" $__sesh_comp_results)
              set --global __sesh_comp_results $completions
              __sesh_debug "Filtered completions are: $__sesh_comp_results"

              # Important not to quote the variable for count to work
              set -l numComps (count $__sesh_comp_results)
              __sesh_debug "numComps: $numComps"

              if test $numComps -eq 1; and test $nospace -ne 0
                  # We must first split on \t to get rid of the descriptions to be
                  # able to check what the actual completion will be.
                  # We don't need descriptions anyway since there is only a single
                  # real completion which the shell will expand immediately.
                  set -l split (string split --max 1 \t $__sesh_comp_results[1])

                  # Fish won't add a space if the completion ends with any
                  # of the following characters: @=/:.,
                  set -l lastChar (string sub -s -1 -- $split)
                  if not string match -r -q "[@=/:.,]" -- "$lastChar"
                      # In other cases, to support the "nospace" directive we trick the shell
                      # by outputting an extra, longer completion.
                      __sesh_debug "Adding second completion to perform nospace directive"
                      set --global __sesh_comp_results $split[1] $split[1].
                      __sesh_debug "Completions are now: $__sesh_comp_results"
                  end
              end

              if test $numComps -eq 0; and test $nofiles -eq 0
                  # To be consistent with bash and zsh, we only trigger file
                  # completion when there are no other completions
                  __sesh_debug "Requesting file completion"
                  return 1
              end
          end

          return 0
      end

      # Since Fish completions are only loaded once the user triggers them, we trigger them ourselves
      # so we can properly delete any completions provided by another script.
      # Only do this if the program can be found, or else fish may print some errors; besides,
      # the existing completions will only be loaded if the program can be found.
      if type -q "sesh"
          # The space after the program name is essential to trigger completion for the program
          # and not completion of the program name itself.
          # Also, we use '> /dev/null 2>&1' since '&>' is not supported in older versions of fish.
          complete --do-complete "sesh " > /dev/null 2>&1
      end

      # Remove any pre-existing completions for the program since we will be handling all of them.
      complete -c sesh -e

      # this will get called after the two calls below and clear the $__sesh_perform_completion_once_result global
      complete -c sesh -n '__sesh_clear_perform_completion_once_result'
      # The call to __sesh_prepare_completions will setup __sesh_comp_results
      # which provides the program's completion choices.
      # If this doesn't require order preservation, we don't use the -k flag
      complete -c sesh -n 'not __sesh_requires_order_preservation && __sesh_prepare_completions' -f -a '$__sesh_comp_results'
      # otherwise we use the -k flag
      complete -k -c sesh -n '__sesh_requires_order_preservation && __sesh_prepare_completions' -f -a '$__sesh_comp_results'
    '';
  };
}
