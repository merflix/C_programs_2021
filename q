GIT-REBASE(1)                                      Git Manual                                     GIT-REBASE(1)

NNAAMMEE
       git-rebase - Reapply commits on top of another base tip

SSYYNNOOPPSSIISS
       _g_i_t _r_e_b_a_s_e [-i | --interactive] [options] [--exec <cmd>] [--onto <newbase>]
               [<upstream> [<branch>]]
       _g_i_t _r_e_b_a_s_e [-i | --interactive] [options] [--exec <cmd>] [--onto <newbase>]
               --root [<branch>]
       _g_i_t _r_e_b_a_s_e --continue | --skip | --abort | --quit | --edit-todo | --show-current-patch

DDEESSCCRRIIPPTTIIOONN
       If <branch> is specified, _g_i_t _r_e_b_a_s_e will perform an automatic ggiitt cchheecckkoouutt <<bbrraanncchh>> before doing
       anything else. Otherwise it remains on the current branch.

       If <upstream> is not specified, the upstream configured in branch.<name>.remote and branch.<name>.merge
       options will be used (see ggiitt--ccoonnffiigg(1) for details) and the ----ffoorrkk--ppooiinntt option is assumed. If you are
       currently not on any branch or if the current branch does not have a configured upstream, the rebase
       will abort.

       All changes made by commits in the current branch but that are not in <upstream> are saved to a
       temporary area. This is the same set of commits that would be shown by ggiitt lloogg <<uuppssttrreeaamm>>....HHEEAADD; or by
       ggiitt lloogg ''ffoorrkk__ppooiinntt''....HHEEAADD, if ----ffoorrkk--ppooiinntt is active (see the description on ----ffoorrkk--ppooiinntt below); or by
       ggiitt lloogg HHEEAADD, if the ----rroooott option is specified.

       The current branch is reset to <upstream>, or <newbase> if the --onto option was supplied. This has the
       exact same effect as ggiitt rreesseett ----hhaarrdd <<uuppssttrreeaamm>> (or <newbase>). ORIG_HEAD is set to point at the tip of
       the branch before the reset.

       The commits that were previously saved into the temporary area are then reapplied to the current branch,
       one by one, in order. Note that any commits in HEAD which introduce the same textual changes as a commit
       in HEAD..<upstream> are omitted (i.e., a patch already accepted upstream with a different commit message
       or timestamp will be skipped).

       It is possible that a merge failure will prevent this process from being completely automatic. You will
       have to resolve any such merge failure and run ggiitt rreebbaassee ----ccoonnttiinnuuee. Another option is to bypass the
       commit that caused the merge failure with ggiitt rreebbaassee ----sskkiipp. To check out the original <branch> and
       remove the .git/rebase-apply working files, use the command ggiitt rreebbaassee ----aabboorrtt instead.

       Assume the following history exists and the current branch is "topic":

                     A---B---C topic
                    /
               D---E---F---G master

       From this point, the result of either of the following commands:

           git rebase master
           git rebase master topic

       would be:

                             A'--B'--C' topic
                            /
               D---E---F---G master

       NNOOTTEE:: The latter form is just a short-hand of ggiitt cchheecckkoouutt ttooppiicc followed by ggiitt rreebbaassee mmaasstteerr. When
       rebase exits ttooppiicc will remain the checked-out branch.

       If the upstream branch already contains a change you have made (e.g., because you mailed a patch which
       was applied upstream), then that commit will be skipped. For example, running ggiitt rreebbaassee mmaasstteerr on the
       following history (in which AA'' and AA introduce the same set of changes, but have different committer
       information):

                     A---B---C topic
                    /
               D---E---A'---F master

       will result in:

                              B'---C' topic
                             /
               D---E---A'---F master

       Here is how you would transplant a topic branch based on one branch to another, to pretend that you
       forked the topic branch from the latter branch, using rreebbaassee ----oonnttoo.

       First let’s assume your _t_o_p_i_c is based on branch _n_e_x_t. For example, a feature developed in _t_o_p_i_c depends
       on some functionality which is found in _n_e_x_t.

               o---o---o---o---o  master
                    \
                     o---o---o---o---o  next
                                      \
                                       o---o---o  topic

       We want to make _t_o_p_i_c forked from branch _m_a_s_t_e_r; for example, because the functionality on which _t_o_p_i_c
       depends was merged into the more stable _m_a_s_t_e_r branch. We want our tree to look like this:

               o---o---o---o---o  master
                   |            \
                   |             o'--o'--o'  topic
                    \
                     o---o---o---o---o  next

       We can get this using the following command:

           git rebase --onto master next topic

       Another example of --onto option is to rebase part of a branch. If we have the following situation:

                                       H---I---J topicB
                                      /
                             E---F---G  topicA
                            /
               A---B---C---D  master

       then the command

           git rebase --onto master topicA topicB

       would result in:

                            H'--I'--J'  topicB
                           /
                           | E---F---G  topicA
                           |/
               A---B---C---D  master

       This is useful when topicB does not depend on topicA.

       A range of commits could also be removed with rebase. If we have the following situation:

               E---F---G---H---I---J  topicA

       then the command

           git rebase --onto topicA~5 topicA~3 topicA

       would result in the removal of commits F and G:

               E---H'---I'---J'  topicA

       This is useful if F and G were flawed in some way, or should not be part of topicA. Note that the
       argument to --onto and the <upstream> parameter can be any valid commit-ish.

       In case of conflict, _g_i_t _r_e_b_a_s_e will stop at the first problematic commit and leave conflict markers in
       the tree. You can use _g_i_t _d_i_f_f to locate the markers (<<<<<<) and make edits to resolve the conflict.
       For each file you edit, you need to tell Git that the conflict has been resolved, typically this would
       be done with

           git add <filename>

       After resolving the conflict manually and updating the index with the desired resolution, you can
       continue the rebasing process with

           git rebase --continue

       Alternatively, you can undo the _g_i_t _r_e_b_a_s_e with

           git rebase --abort

CCOONNFFIIGGUURRAATTIIOONN
       rebase.stat
           Whether to show a diffstat of what changed upstream since the last rebase. False by default.

       rebase.autoSquash
           If set to true enable ----aauuttoossqquuaasshh option by default.

       rebase.autoStash
           When set to true, automatically create a temporary stash entry before the operation begins, and
           apply it after the operation ends. This means that you can run rebase on a dirty worktree. However,
           use with care: the final stash application after a successful rebase might result in non-trivial
           conflicts. This option can be overridden by the ----nnoo--aauuttoossttaasshh and ----aauuttoossttaasshh options of ggiitt--
           rreebbaassee(1). Defaults to false.

       rebase.missingCommitsCheck
           If set to "warn", git rebase -i will print a warning if some commits are removed (e.g. a line was
           deleted), however the rebase will still proceed. If set to "error", it will print the previous
           warning and stop the rebase, _g_i_t _r_e_b_a_s_e _-_-_e_d_i_t_-_t_o_d_o can then be used to correct the error. If set to
           "ignore", no checking is done. To drop a commit without warning or error, use the ddrroopp command in
           the todo list. Defaults to "ignore".

       rebase.instructionFormat
           A format string, as specified in ggiitt--lloogg(1), to be used for the todo list during an interactive
           rebase. The format will automatically have the long commit hash prepended to the format.

       rebase.abbreviateCommands
           If set to true, ggiitt rreebbaassee will use abbreviated command names in the todo list resulting in
           something like this:

                       p deadbee The oneline of the commit
                       p fa1afe1 The oneline of the next commit
                       ...

           instead of:

                       pick deadbee The oneline of the commit
                       pick fa1afe1 The oneline of the next commit
                       ...

           Defaults to false.

OOPPTTIIOONNSS
       --onto <newbase>
           Starting point at which to create the new commits. If the --onto option is not specified, the
           starting point is <upstream>. May be any valid commit, and not just an existing branch name.

           As a special case, you may use "A...B" as a shortcut for the merge base of A and B if there is
           exactly one merge base. You can leave out at most one of A and B, in which case it defaults to HEAD.

       <upstream>
           Upstream branch to compare against. May be any valid commit, not just an existing branch name.
           Defaults to the configured upstream for the current branch.

       <branch>
           Working branch; defaults to HEAD.

       --continue
           Restart the rebasing process after having resolved a merge conflict.

       --abort
           Abort the rebase operation and reset HEAD to the original branch. If <branch> was provided when the
           rebase operation was started, then HEAD will be reset to <branch>. Otherwise HEAD will be reset to
           where it was when the rebase operation was started.

       --quit
           Abort the rebase operation but HEAD is not reset back to the original branch. The index and working
           tree are also left unchanged as a result.

       --keep-empty
           Keep the commits that do not change anything from its parents in the result.

       --allow-empty-message
           By default, rebasing commits with an empty message will fail. This option overrides that behavior,
           allowing commits with empty messages to be rebased.

       --skip
           Restart the rebasing process by skipping the current patch.

       --edit-todo
           Edit the todo list during an interactive rebase.

       --show-current-patch
           Show the current patch in an interactive rebase or when rebase is stopped because of conflicts. This
           is the equivalent of ggiitt sshhooww RREEBBAASSEE__HHEEAADD.

       -m, --merge
           Use merging strategies to rebase. When the recursive (default) merge strategy is used, this allows
           rebase to be aware of renames on the upstream side.

           Note that a rebase merge works by replaying each commit from the working branch on top of the
           <upstream> branch. Because of this, when a merge conflict happens, the side reported as _o_u_r_s is the
           so-far rebased series, starting with <upstream>, and _t_h_e_i_r_s is the working branch. In other words,
           the sides are swapped.

       -s <strategy>, --strategy=<strategy>
           Use the given merge strategy. If there is no --ss option _g_i_t _m_e_r_g_e_-_r_e_c_u_r_s_i_v_e is used instead. This
           implies --merge.

           Because _g_i_t _r_e_b_a_s_e replays each commit from the working branch on top of the <upstream> branch using
           the given strategy, using the _o_u_r_s strategy simply discards all patches from the <branch>, which
           makes little sense.

       -X <strategy-option>, --strategy-option=<strategy-option>
           Pass the <strategy-option> through to the merge strategy. This implies ----mmeerrggee and, if no strategy
           has been specified, --ss rreeccuurrssiivvee. Note the reversal of _o_u_r_s and _t_h_e_i_r_s as noted above for the --mm
           option.

       -S[<keyid>], --gpg-sign[=<keyid>]
           GPG-sign commits. The kkeeyyiidd argument is optional and defaults to the committer identity; if
           specified, it must be stuck to the option without a space.

       -q, --quiet
           Be quiet. Implies --no-stat.

       -v, --verbose
           Be verbose. Implies --stat.

       --stat
           Show a diffstat of what changed upstream since the last rebase. The diffstat is also controlled by
           the configuration option rebase.stat.

       -n, --no-stat
           Do not show a diffstat as part of the rebase process.

       --no-verify
           This option bypasses the pre-rebase hook. See also ggiitthhooookkss(5).

       --verify
           Allows the pre-rebase hook to run, which is the default. This option can be used to override
           --no-verify. See also ggiitthhooookkss(5).

       -C<n>
           Ensure at least <n> lines of surrounding context match before and after each change. When fewer
           lines of surrounding context exist they all must match. By default no context is ever ignored.

       -f, --force-rebase
           Force a rebase even if the current branch is up to date and the command without ----ffoorrccee would return
           without doing anything.

           You may find this (or --no-ff with an interactive rebase) helpful after reverting a topic branch
           merge, as this option recreates the topic branch with fresh commits so it can be remerged
           successfully without needing to "revert the reversion" (see the rreevveerrtt--aa--ffaauullttyy--mmeerrggee HHooww--TToo[1] for
           details).

       --fork-point, --no-fork-point
           Use reflog to find a better common ancestor between <upstream> and <branch> when calculating which
           commits have been introduced by <branch>.

           When --fork-point is active, _f_o_r_k___p_o_i_n_t will be used instead of <upstream> to calculate the set of
           commits to rebase, where _f_o_r_k___p_o_i_n_t is the result of ggiitt mmeerrggee--bbaassee ----ffoorrkk--ppooiinntt <<uuppssttrreeaamm>> <<bbrraanncchh>>
           command (see ggiitt--mmeerrggee--bbaassee(1)). If _f_o_r_k___p_o_i_n_t ends up being empty, the <upstream> will be used as a
           fallback.

           If either <upstream> or --root is given on the command line, then the default is ----nnoo--ffoorrkk--ppooiinntt,
           otherwise the default is ----ffoorrkk--ppooiinntt.

       --ignore-whitespace, --whitespace=<option>
           These flag are passed to the _g_i_t _a_p_p_l_y program (see ggiitt--aappppllyy(1)) that applies the patch.
           Incompatible with the --interactive option.

       --committer-date-is-author-date, --ignore-date
           These flags are passed to _g_i_t _a_m to easily change the dates of the rebased commits (see ggiitt--aamm(1)).
           Incompatible with the --interactive option.

       --signoff
           This flag is passed to _g_i_t _a_m to sign off all the rebased commits (see ggiitt--aamm(1)). Incompatible with
           the --interactive option.

       -i, --interactive
           Make a list of the commits which are about to be rebased. Let the user edit that list before
           rebasing. This mode can also be used to split commits (see SPLITTING COMMITS below).

           The commit list format can be changed by setting the configuration option rebase.instructionFormat.
           A customized instruction format will automatically have the long commit hash prepended to the
           format.

       -p, --preserve-merges
           Recreate merge commits instead of flattening the history by replaying commits a merge commit
           introduces. Merge conflict resolutions or manual amendments to merge commits are not preserved.

           This uses the ----iinntteerraaccttiivvee machinery internally, but combining it with the ----iinntteerraaccttiivvee option
           explicitly is generally not a good idea unless you know what you are doing (see BUGS below).

       -x <cmd>, --exec <cmd>
           Append "exec <cmd>" after each line creating a commit in the final history. <cmd> will be
           interpreted as one or more shell commands.

           You may execute several commands by either using one instance of ----eexxeecc with several commands:

               git rebase -i --exec "cmd1 && cmd2 && ..."

           or by giving more than one ----eexxeecc:

               git rebase -i --exec "cmd1" --exec "cmd2" --exec ...

           If ----aauuttoossqquuaasshh is used, "exec" lines will not be appended for the intermediate commits, and will
           only appear at the end of each squash/fixup series.

           This uses the ----iinntteerraaccttiivvee machinery internally, but it can be run without an explicit
           ----iinntteerraaccttiivvee.

       --root
           Rebase all commits reachable from <branch>, instead of limiting them with an <upstream>. This allows
           you to rebase the root commit(s) on a branch. When used with --onto, it will skip changes already
           contained in <newbase> (instead of <upstream>) whereas without --onto it will operate on every
           change. When used together with both --onto and --preserve-merges, _a_l_l root commits will be
           rewritten to have <newbase> as parent instead.

       --autosquash, --no-autosquash
           When the commit log message begins with "squash! ..." (or "fixup! ..."), and there is already a
           commit in the todo list that matches the same ......, automatically modify the todo list of rebase -i
           so that the commit marked for squashing comes right after the commit to be modified, and change the
           action of the moved commit from ppiicckk to ssqquuaasshh (or ffiixxuupp). A commit matches the ......  if the commit
           subject matches, or if the ......  refers to the commit’s hash. As a fall-back, partial matches of the
           commit subject work, too. The recommended way to create fixup/squash commits is by using the
           ----ffiixxuupp/----ssqquuaasshh options of ggiitt--ccoommmmiitt(1).

           This option is only valid when the ----iinntteerraaccttiivvee option is used.

           If the ----aauuttoossqquuaasshh option is enabled by default using the configuration variable rreebbaassee..aauuttooSSqquuaasshh,
           this option can be used to override and disable this setting.

       --autostash, --no-autostash
           Automatically create a temporary stash entry before the operation begins, and apply it after the
           operation ends. This means that you can run rebase on a dirty worktree. However, use with care: the
           final stash application after a successful rebase might result in non-trivial conflicts.

       --no-ff
           With --interactive, cherry-pick all rebased commits instead of fast-forwarding over the unchanged
           ones. This ensures that the entire history of the rebased branch is composed of new commits.

           Without --interactive, this is a synonym for --force-rebase.

           You may find this helpful after reverting a topic branch merge, as this option recreates the topic
           branch with fresh commits so it can be remerged successfully without needing to "revert the
           reversion" (see the rreevveerrtt--aa--ffaauullttyy--mmeerrggee HHooww--TToo[1] for details).

MMEERRGGEE SSTTRRAATTEEGGIIEESS
       The merge mechanism (ggiitt mmeerrggee and ggiitt ppuullll commands) allows the backend _m_e_r_g_e _s_t_r_a_t_e_g_i_e_s to be chosen
       with --ss option. Some strategies can also take their own options, which can be passed by giving
       --XX<<ooppttiioonn>> arguments to ggiitt mmeerrggee and/or ggiitt ppuullll.

       resolve
           This can only resolve two heads (i.e. the current branch and another branch you pulled from) using a
           3-way merge algorithm. It tries to carefully detect criss-cross merge ambiguities and is considered
           generally safe and fast.

       recursive
           This can only resolve two heads using a 3-way merge algorithm. When there is more than one common
           ancestor that can be used for 3-way merge, it creates a merged tree of the common ancestors and uses
           that as the reference tree for the 3-way merge. This has been reported to result in fewer merge
           conflicts without causing mismerges by tests done on actual merge commits taken from Linux 2.6
           kernel development history. Additionally this can detect and handle merges involving renames. This
           is the default merge strategy when pulling or merging one branch.

           The _r_e_c_u_r_s_i_v_e strategy can take the following options:

           ours
               This option forces conflicting hunks to be auto-resolved cleanly by favoring _o_u_r version.
               Changes from the other tree that do not conflict with our side are reflected to the merge
               result. For a binary file, the entire contents are taken from our side.

               This should not be confused with the _o_u_r_s merge strategy, which does not even look at what the
               other tree contains at all. It discards everything the other tree did, declaring _o_u_r history
               contains all that happened in it.

           theirs
               This is the opposite of _o_u_r_s; note that, unlike _o_u_r_s, there is no _t_h_e_i_r_s merge strategy to
               confuse this merge option with.

           patience
               With this option, _m_e_r_g_e_-_r_e_c_u_r_s_i_v_e spends a little extra time to avoid mismerges that sometimes
               occur due to unimportant matching lines (e.g., braces from distinct functions). Use this when
               the branches to be merged have diverged wildly. See also ggiitt--ddiiffff(1) ----ppaattiieennccee.

           diff-algorithm=[patience|minimal|histogram|myers]
               Tells _m_e_r_g_e_-_r_e_c_u_r_s_i_v_e to use a different diff algorithm, which can help avoid mismerges that
               occur due to unimportant matching lines (such as braces from distinct functions). See also ggiitt--
               ddiiffff(1) ----ddiiffff--aallggoorriitthhmm.

           ignore-space-change, ignore-all-space, ignore-space-at-eol, ignore-cr-at-eol
               Treats lines with the indicated type of whitespace change as unchanged for the sake of a
               three-way merge. Whitespace changes mixed with other changes to a line are not ignored. See also
               ggiitt--ddiiffff(1) --bb, --ww, ----iiggnnoorree--ssppaaccee--aatt--eeooll, and ----iiggnnoorree--ccrr--aatt--eeooll.

               ·   If _t_h_e_i_r version only introduces whitespace changes to a line, _o_u_r version is used;

               ·   If _o_u_r version introduces whitespace changes but _t_h_e_i_r version includes a substantial
                   change, _t_h_e_i_r version is used;

               ·   Otherwise, the merge proceeds in the usual way.

           renormalize
               This runs a virtual check-out and check-in of all three stages of a file when resolving a
               three-way merge. This option is meant to be used when merging branches with different clean
               filters or end-of-line normalization rules. See "Merging branches with differing
               checkin/checkout attributes" in ggiittaattttrriibbuutteess(5) for details.

           no-renormalize
               Disables the rreennoorrmmaalliizzee option. This overrides the mmeerrggee..rreennoorrmmaalliizzee configuration variable.

           no-renames
               Turn off rename detection. See also ggiitt--ddiiffff(1) ----nnoo--rreennaammeess.

           find-renames[=<n>]
               Turn on rename detection, optionally setting the similarity threshold. This is the default. See
               also ggiitt--ddiiffff(1) ----ffiinndd--rreennaammeess.

           rename-threshold=<n>
               Deprecated synonym for ffiinndd--rreennaammeess==<<nn>>.

           subtree[=<path>]
               This option is a more advanced form of _s_u_b_t_r_e_e strategy, where the strategy makes a guess on how
               two trees must be shifted to match with each other when merging. Instead, the specified path is
               prefixed (or stripped from the beginning) to make the shape of two trees to match.

       octopus
           This resolves cases with more than two heads, but refuses to do a complex merge that needs manual
           resolution. It is primarily meant to be used for bundling topic branch heads together. This is the
           default merge strategy when pulling or merging more than one branch.

       ours
           This resolves any number of heads, but the resulting tree of the merge is always that of the current
           branch head, effectively ignoring all changes from all other branches. It is meant to be used to
           supersede old development history of side branches. Note that this is different from the -Xours
           option to the _r_e_c_u_r_s_i_v_e merge strategy.

       subtree
           This is a modified recursive strategy. When merging trees A and B, if B corresponds to a subtree of
           A, B is first adjusted to match the tree structure of A, instead of reading the trees at the same
           level. This adjustment is also done to the common ancestor tree.

       With the strategies that use 3-way merge (including the default, _r_e_c_u_r_s_i_v_e), if a change is made on both
       branches, but later reverted on one of the branches, that change will be present in the merged result;
       some people find this behavior confusing. It occurs because only the heads and the merge base are
       considered when performing a merge, not the individual commits. The merge algorithm therefore considers
       the reverted change as no change at all, and substitutes the changed version instead.

NNOOTTEESS
       You should understand the implications of using _g_i_t _r_e_b_a_s_e on a repository that you share. See also
       RECOVERING FROM UPSTREAM REBASE below.

       When the git-rebase command is run, it will first execute a "pre-rebase" hook if one exists. You can use
       this hook to do sanity checks and reject the rebase if it isn’t appropriate. Please see the template
       pre-rebase hook script for an example.

       Upon completion, <branch> will be the current branch.

IINNTTEERRAACCTTIIVVEE MMOODDEE
       Rebasing interactively means that you have a chance to edit the commits which are rebased. You can
       reorder the commits, and you can remove them (weeding out bad or otherwise unwanted patches).

       The interactive mode is meant for this type of workflow:

        1. have a wonderful idea

        2. hack on the code

        3. prepare a series for submission

        4. submit

       where point 2. consists of several instances of

       a) regular use

        1. finish something worthy of a commit

        2. commit

       b) independent fixup

        1. realize that something does not work

        2. fix that

        3. commit it

       Sometimes the thing fixed in b.2. cannot be amended to the not-quite perfect commit it fixes, because
       that commit is buried deeply in a patch series. That is exactly what interactive rebase is for: use it
       after plenty of "a"s and "b"s, by rearranging and editing commits, and squashing multiple commits into
       one.

       Start it with the last commit you want to retain as-is:

           git rebase -i <after-this-commit>

       An editor will be fired up with all the commits in your current branch (ignoring merge commits), which
       come after the given commit. You can reorder the commits in this list to your heart’s content, and you
       can remove them. The list looks more or less like this:

           pick deadbee The oneline of this commit
           pick fa1afe1 The oneline of the next commit
           ...

       The oneline descriptions are purely for your pleasure; _g_i_t _r_e_b_a_s_e will not look at them but at the
       commit names ("deadbee" and "fa1afe1" in this example), so do not delete or edit the names.

       By replacing the command "pick" with the command "edit", you can tell _g_i_t _r_e_b_a_s_e to stop after applying
       that commit, so that you can edit the files and/or the commit message, amend the commit, and continue
       rebasing.

       If you just want to edit the commit message for a commit, replace the command "pick" with the command
       "reword".

       To drop a commit, replace the command "pick" with "drop", or just delete the matching line.

       If you want to fold two or more commits into one, replace the command "pick" for the second and
       subsequent commits with "squash" or "fixup". If the commits had different authors, the folded commit
       will be attributed to the author of the first commit. The suggested commit message for the folded commit
       is the concatenation of the commit messages of the first commit and of those with the "squash" command,
       but omits the commit messages of commits with the "fixup" command.

       _g_i_t _r_e_b_a_s_e will stop when "pick" has been replaced with "edit" or when a command fails due to merge
       errors. When you are done editing and/or resolving conflicts you can continue with ggiitt rreebbaassee
       ----ccoonnttiinnuuee.

       For example, if you want to reorder the last 5 commits, such that what was HEAD~4 becomes the new HEAD.
       To achieve that, you would call _g_i_t _r_e_b_a_s_e like this:

           $ git rebase -i HEAD~5

       And move the first patch to the end of the list.

       You might want to preserve merges, if you have a history like this:

                      X
                       \
                    A---M---B
                   /
           ---o---O---P---Q

       Suppose you want to rebase the side branch starting at "A" to "Q". Make sure that the current HEAD is
       "B", and call

           $ git rebase -i -p --onto Q O

       Reordering and editing commits usually creates untested intermediate steps. You may want to check that
       your history editing did not break anything by running a test, or at least recompiling at intermediate
       points in history by using the "exec" command (shortcut "x"). You may do so by creating a todo list like
       this one:

           pick deadbee Implement feature XXX
           fixup f1a5c00 Fix to feature XXX
           exec make
           pick c0ffeee The oneline of the next commit
           edit deadbab The oneline of the commit after
           exec cd subdir; make test
           ...

       The interactive rebase will stop when a command fails (i.e. exits with non-0 status) to give you an
       opportunity to fix the problem. You can continue with ggiitt rreebbaassee ----ccoonnttiinnuuee.

       The "exec" command launches the command in a shell (the one specified in $$SSHHEELLLL, or the default shell if
       $$SSHHEELLLL is not set), so you can use shell features (like "cd", ">", ";" ...). The command is run from the
       root of the working tree.

           $ git rebase -i --exec "make test"

       This command lets you check that intermediate commits are compilable. The todo list becomes like that:

           pick 5928aea one
           exec make test
           pick 04d0fda two
           exec make test
           pick ba46169 three
           exec make test
           pick f4593f9 four
           exec make test

SSPPLLIITTTTIINNGG CCOOMMMMIITTSS
       In interactive mode, you can mark commits with the action "edit". However, this does not necessarily
       mean that _g_i_t _r_e_b_a_s_e expects the result of this edit to be exactly one commit. Indeed, you can undo the
       commit, or you can add other commits. This can be used to split a commit into two:

       ·   Start an interactive rebase with ggiitt rreebbaassee --ii <<ccoommmmiitt>>^^, where <commit> is the commit you want to
           split. In fact, any commit range will do, as long as it contains that commit.

       ·   Mark the commit you want to split with the action "edit".

       ·   When it comes to editing that commit, execute ggiitt rreesseett HHEEAADD^^. The effect is that the HEAD is
           rewound by one, and the index follows suit. However, the working tree stays the same.

       ·   Now add the changes to the index that you want to have in the first commit. You can use ggiitt aadddd
           (possibly interactively) or _g_i_t _g_u_i (or both) to do that.

       ·   Commit the now-current index with whatever commit message is appropriate now.

       ·   Repeat the last two steps until your working tree is clean.

       ·   Continue the rebase with ggiitt rreebbaassee ----ccoonnttiinnuuee.

       If you are not absolutely sure that the intermediate revisions are consistent (they compile, pass the
       testsuite, etc.) you should use _g_i_t _s_t_a_s_h to stash away the not-yet-committed changes after each commit,
       test, and amend the commit if fixes are necessary.

RREECCOOVVEERRIINNGG FFRROOMM UUPPSSTTRREEAAMM RREEBBAASSEE
       Rebasing (or any other form of rewriting) a branch that others have based work on is a bad idea: anyone
       downstream of it is forced to manually fix their history. This section explains how to do the fix from
       the downstream’s point of view. The real fix, however, would be to avoid rebasing the upstream in the
       first place.

       To illustrate, suppose you are in a situation where someone develops a _s_u_b_s_y_s_t_e_m branch, and you are
       working on a _t_o_p_i_c that is dependent on this _s_u_b_s_y_s_t_e_m. You might end up with a history like the
       following:

               o---o---o---o---o---o---o---o  master
                    \
                     o---o---o---o---o  subsystem
                                      \
                                       *---*---*  topic

       If _s_u_b_s_y_s_t_e_m is rebased against _m_a_s_t_e_r, the following happens:

               o---o---o---o---o---o---o---o  master
                    \                       \
                     o---o---o---o---o       o'--o'--o'--o'--o'  subsystem
                                      \
                                       *---*---*  topic

       If you now continue development as usual, and eventually merge _t_o_p_i_c to _s_u_b_s_y_s_t_e_m, the commits from
       _s_u_b_s_y_s_t_e_m will remain duplicated forever:

               o---o---o---o---o---o---o---o  master
                    \                       \
                     o---o---o---o---o       o'--o'--o'--o'--o'--M  subsystem
                                      \                         /
                                       *---*---*-..........-*--*  topic

       Such duplicates are generally frowned upon because they clutter up history, making it harder to follow.
       To clean things up, you need to transplant the commits on _t_o_p_i_c to the new _s_u_b_s_y_s_t_e_m tip, i.e., rebase
       _t_o_p_i_c. This becomes a ripple effect: anyone downstream from _t_o_p_i_c is forced to rebase too, and so on!

       There are two kinds of fixes, discussed in the following subsections:

       Easy case: The changes are literally the same.
           This happens if the _s_u_b_s_y_s_t_e_m rebase was a simple rebase and had no conflicts.

       Hard case: The changes are not the same.
           This happens if the _s_u_b_s_y_s_t_e_m rebase had conflicts, or used ----iinntteerraaccttiivvee to omit, edit, squash, or
           fixup commits; or if the upstream used one of ccoommmmiitt ----aammeenndd, rreesseett, or ffiilltteerr--bbrraanncchh.

   TThhee eeaassyy ccaassee
       Only works if the changes (patch IDs based on the diff contents) on _s_u_b_s_y_s_t_e_m are literally the same
       before and after the rebase _s_u_b_s_y_s_t_e_m did.

       In that case, the fix is easy because _g_i_t _r_e_b_a_s_e knows to skip changes that are already present in the
       new upstream. So if you say (assuming you’re on _t_o_p_i_c)

               $ git rebase subsystem

       you will end up with the fixed history

               o---o---o---o---o---o---o---o  master
                                            \
                                             o'--o'--o'--o'--o'  subsystem
                                                              \
                                                               *---*---*  topic

   TThhee hhaarrdd ccaassee
       Things get more complicated if the _s_u_b_s_y_s_t_e_m changes do not exactly correspond to the ones before the
       rebase.

           NNoottee
           While an "easy case recovery" sometimes appears to be successful even in the hard case, it may have
           unintended consequences. For example, a commit that was removed via ggiitt rreebbaassee ----iinntteerraaccttiivvee will be
           rreessuurrrreecctteedd!

       The idea is to manually tell _g_i_t _r_e_b_a_s_e "where the old _s_u_b_s_y_s_t_e_m ended and your _t_o_p_i_c began", that is,
       what the old merge-base between them was. You will have to find a way to name the last commit of the old
       _s_u_b_s_y_s_t_e_m, for example:

       ·   With the _s_u_b_s_y_s_t_e_m reflog: after _g_i_t _f_e_t_c_h, the old tip of _s_u_b_s_y_s_t_e_m is at ssuubbssyysstteemm@@{{11}}. Subsequent
           fetches will increase the number. (See ggiitt--rreefflloogg(1).)

       ·   Relative to the tip of _t_o_p_i_c: knowing that your _t_o_p_i_c has three commits, the old tip of _s_u_b_s_y_s_t_e_m
           must be ttooppiicc~~33.

       You can then transplant the old ssuubbssyysstteemm....ttooppiicc to the new tip by saying (for the reflog case, and
       assuming you are on _t_o_p_i_c already):

               $ git rebase --onto subsystem subsystem@{1}

       The ripple effect of a "hard case" recovery is especially bad: _e_v_e_r_y_o_n_e downstream from _t_o_p_i_c will now
       have to perform a "hard case" recovery too!

BBUUGGSS
       The todo list presented by ----pprreesseerrvvee--mmeerrggeess ----iinntteerraaccttiivvee does not represent the topology of the
       revision graph. Editing commits and rewording their commit messages should work fine, but attempts to
       reorder commits tend to produce counterintuitive results.

       For example, an attempt to rearrange

           1 --- 2 --- 3 --- 4 --- 5

       to

           1 --- 2 --- 4 --- 3 --- 5

       by moving the "pick 4" line will result in the following history:

                   3
                  /
           1 --- 2 --- 4 --- 5

GGIITT
       Part of the ggiitt(1) suite

NNOOTTEESS
        1. revert-a-faulty-merge How-To
           file:///usr/share/doc/git/html/howto/revert-a-faulty-merge.html

Git 2.17.1                                         03/04/2021                                     GIT-REBASE(1)
