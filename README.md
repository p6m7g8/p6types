# p6types

## Table of Contents


### p6types
- [p6types](#p6types)
  - [Badges](#badges)
  - [Distributions](#distributions)
  - [Summary](#summary)
  - [Contributing](#contributing)
  - [Code of Conduct](#code-of-conduct)
  - [Changes](#changes)
    - [Usage](#usage)
  - [Author](#author)

### Badges

[![License](https://img.shields.io/badge/License-Apache%202.0-yellowgreen.svg)](https://opensource.org/licenses/Apache-2.0)
[![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/p6m7g8/p6types)
[![Mergify](https://img.shields.io/endpoint.svg?url=https://gh.mergify.io/badges/p6m7g8/p6types/&style=flat)](https://mergify.io)
[![codecov](https://codecov.io/gh/p6m7g8/p6types/branch/master/graph/badge.svg?token=14Yj1fZbew)](https://codecov.io/gh/p6m7g8/p6types)
[![Known Vulnerabilities](https://snyk.io/test/github/p6m7g8/p6types/badge.svg?targetFile=package.json)](https://snyk.io/test/github/p6m7g8/p6types?targetFile=package.json)
[![Gihub repo dependents](https://badgen.net/github/dependents-repo/p6m7g8/p6types)](https://github.com/p6m7g8/p6types/network/dependents?dependent_type=REPOSITORY)
[![Gihub package dependents](https://badgen.net/github/dependents-pkg/p6m7g8/p6types)](https://github.com/p6m7g8/p6types/network/dependents?dependent_type=PACKAGE)

## Summary

## Contributing

- [How to Contribute](CONTRIBUTING.md)

## Code of Conduct

- [Code of Conduct](https://github.com/p6m7g8/.github/blob/master/CODE_OF_CONDUCT.md)

## Changes

- [Change Log](CHANGELOG.md)

## Usage

### p6types:

#### p6types/init.zsh:

- p6df::modules::p6types::deps()
- p6df::modules::p6types::init()

### ../p6types/lib:

#### ../p6types/lib/_store.sh:

- code rc = p6_store_is(store)
- code rc = p6_store_persist_is(store)
- obj copy = p6_store_copy(store)
- obj ref = p6_store_ref(store)
- obj store = p6_store_create(name, max_objs)
- p6_store_destroy(store)
- p6_store_persist(store)
- p6_store_persist_un(store)
#### ../p6types/lib/api.sh:

- bool bool = p6_obj_persist_is(obj)
- code rc = p6_obj_is(obj)
- code rc = p6_obj_iter_more(obj, [var=default])
- item item = p6_obj_iter_current(obj, [var=default])
- item item = p6_obj_iter_i(obj, [var=default], i)
- obj copy = p6_obj_copy(obj)
- obj obj = p6_obj_assign(obj)
- obj obj = p6_obj_create([class=obj], [max_objs=])
- obj rlist = p6_obj_grep(obj, pattern)
- p6_obj_destroy(obj)
- p6_obj_display(obj)
- p6_obj_item_add(obj, ...)
- p6_obj_item_delete(obj, ...)
- p6_obj_item_get(obj, ...)
- p6_obj_iter_ate(obj, [var=default], [move=1])
- p6_obj_iter_foreach(obj, var, callback, [filter_callback=], ...)
- p6_obj_lc(obj)
- p6_obj_persist(obj)
- p6_obj_persist_un(obj)
- p6_obj_reverse(obj)
- p6_obj_splice(obj, start, new)
- p6_obj_trim(obj)
- p6_obj_uc(obj)
- size_t index = p6_obj_iter_index(obj, [var=default])
- size_t old_length = p6_obj_length(obj, new)
- size_t rc = p6_obj_compare(a, b)
- str key = p6_obj_item_key(item)
- str old_class = p6_obj_class(obj, new)
- str old_val = p6_obj_item_set(obj, ...)
- str val = p6_obj_item_value(item)
#### ../p6types/lib/p6_return.sh:

- path item = p6_return_item(item)
- path obj = p6_return_obj()

### _store:

#### _store/hash.sh:

- item pair_dir = p6_store_hash_iter_i(store, key, i)
- p6_store_hash_create(store, name)
- str old = p6_store_hash_set(store, name, key, val)
- str old_val = p6_store_hash_delete(store, name, key)
- str old_val = p6_store_hash_item_set(store, ...)
- str val = p6_store_hash_get(store, name, key)
- str val = p6_store_hash_item_get(store, ...)
#### _store/iter.sh:

- code rc = p6_store_iter_exists(store, name)
- p6_store_iter_create(store, name)
- p6_store_iter_destroy(store, name)
- p6_store_iter_move(store, name, delta)
- size_t val = p6_store_iter_current(store, name)
#### _store/list.sh:

- item item = p6_store_list_get(store, name, i)
- item old = p6_store_list_delete(store, name, i)
- p6_store_list_create(store, name)
- p6_store_list_set(store, name, i_val, new)
- size_t j = p6_store_list_item_delete(store, name, old)
- str i_val = p6_store_list_add(store, name, new)
- str old_val = p6_store_list_item_set(store, ...)
- str val = p6_store_list_item_get(store, ...)
#### _store/scalar.sh:

- p6_store_scalar_create(store, name)
- str val = p6_store_scalar_get(store, name)
- str val = p6_store_scalar_set(store, name, new)
#### _store/string.sh:

- p6_store_string_create(store, name)
- str old_val = p6_store_string_item_set(store, ...)
- str val = p6_store_string_get(store, name)
- str val = p6_store_string_item_get(store, ...)
- str val = p6_store_string_set(store, name, new)


## Author

Philip M . Gollucci <pgollucci@p6m7g8.com>
