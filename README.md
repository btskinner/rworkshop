# Workshop on R

Repository holding class materials and website files for R workshop
held on 15/16 January 2018 at the University of Virginia.

## Branches

Setup based on this [gist](https://gist.github.com/chrisjacob/825950).

- `master` branch holds primary files and ignores `_site` subdirectory
  (local to machine)
- `gh-pages` branch works in `_site` directory and holds files for
  website  
  
## To build

1. On `master` branch in top-level directory, run `bundle exec jekyll build`
2. (on `master` branch) `add`, `commit`, and `push` to remote `master`
3. `cd` into `_site` subdirectory
4. (on `gh-pages` branch now) `add`, `commit`, and `push` to remote
   `gh-pages`
