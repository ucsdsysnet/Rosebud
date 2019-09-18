rel_subdir="corundum"

# determine repo absolute path
if [ -n "$rel_subdir" ]; then
    # cd to script dir
    SOURCE="${BASH_SOURCE[0]}"
    while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
      DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
      SOURCE="$(readlink "$SOURCE")"
      [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

    cd "$DIR"

    # relative path to script dir
    git-absolute-path () {
        fullpath=$(readlink -f "$1")
        gitroot="$(git rev-parse --show-toplevel)" || return 1
        [[ "$fullpath" =~ "$gitroot" ]] && echo "${fullpath/$gitroot\//}"
    }

    subdir="$(git-absolute-path .)/$rel_subdir"
fi

cd $(git rev-parse --show-toplevel)

git remote add -f corundumrepo https://github.com/ucsdsysnet/corundum.git
git checkout -b staging-branch corundumrepo/master
git subtree split -P fpga/common -b corundumlib
git checkout master
if [ ! -d "$subdir" ]; then
  git subtree add -P "$subdir" --squash corundumlib
else
  git subtree merge -P "$subdir" --squash corundumlib
fi
git branch -D staging-branch corundumlib
git remote rm corundumrepo
