"""Provides a macro to import all TensorFlow Serving dependencies.

Some of the external dependencies need to be initialized. To do this, duplicate
the initialization code from TensorFlow Serving's WORKSPACE file.
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "new_git_repository")

def tf_serving_workspace():
    """All TensorFlow Serving external dependencies."""

    # ===== Bazel skylib dependency =====
    http_archive(
        name = "bazel_skylib",
        sha256 = "74d544d96f4a5bb630d465ca8bbcfe231e3594e5aae57e1edbf17a6eb3ca2506",
        url = "https://github.com/bazelbuild/bazel-skylib/releases/download/1.3.0/bazel-skylib-1.3.0.tar.gz",
    )

    # ===== Bazel package rules dependency =====
    http_archive(
        name = "rules_pkg",
        sha256 = "451e08a4d78988c06fa3f9306ec813b836b1d076d0f055595444ba4ff22b867f",
        url = "https://github.com/bazelbuild/rules_pkg/releases/download/0.7.1/rules_pkg-0.7.1.tar.gz",
    )

    # ===== RapidJSON (rapidjson.org) dependency =====
    http_archive(
        name = "com_github_tencent_rapidjson",
        url = "https://github.com/Tencent/rapidjson/archive/v1.1.0.zip",
        sha256 = "8e00c38829d6785a2dfb951bb87c6974fa07dfe488aa5b25deec4b8bc0f6a3ab",
        strip_prefix = "rapidjson-1.1.0",
        build_file = "@//third_party/rapidjson:BUILD",
    )

    # ===== libevent (libevent.org) dependency =====
    http_archive(
        name = "com_github_libevent_libevent",
        url = "https://github.com/libevent/libevent/archive/release-2.1.8-stable.zip",
        sha256 = "70158101eab7ed44fd9cc34e7f247b3cae91a8e4490745d9d6eb7edc184e4d96",
        strip_prefix = "libevent-release-2.1.8-stable",
        build_file = "@//third_party/libevent:BUILD",
    )

    # ===== ICU dependency =====
    # Note: This overrides the dependency from TensorFlow with a version
    # that contains all data.
    http_archive(
        name = "icu",
        strip_prefix = "icu-release-64-2",
        sha256 = "dfc62618aa4bd3ca14a3df548cd65fe393155edd213e49c39f3a30ccd618fc27",
        urls = [
            "https://storage.googleapis.com/mirror.tensorflow.org/github.com/unicode-org/icu/archive/release-64-2.zip",
            "https://github.com/unicode-org/icu/archive/release-64-2.zip",
        ],
        build_file = "//third_party/icu:BUILD",
        patches = ["//third_party/icu:data.patch"],
        patch_args = ["-p1", "-s"],
    )

    # ===== TF.Text dependencies
    # NOTE: Before updating this version, you must update the test model
    # and double check all custom ops have a test:
    # https://github.com/tensorflow/text/blob/master/oss_scripts/model_server/save_models.py
    http_archive(
        name = "org_tensorflow_text",
        sha256 = "556b516d917265a03e2712389e39e14f6d0faed6421215bd8c1e83d98fd270fb",
        strip_prefix = "text-2.11.0",
        url = "https://github.com/tensorflow/text/archive/v2.11.0.zip",
        patches = ["@//third_party/tf_text:tftext.patch"],
        patch_args = ["-p1"],
        repo_mapping = {"@com_google_re2": "@com_googlesource_code_re2"},
    )

    http_archive(
        name = "com_google_sentencepiece",
        strip_prefix = "sentencepiece-0.1.96",
        sha256 = "8409b0126ebd62b256c685d5757150cf7fcb2b92a2f2b98efb3f38fc36719754",
        urls = [
            "https://github.com/google/sentencepiece/archive/refs/tags/v0.1.96.zip",
        ],
        build_file = "//third_party/sentencepiece:BUILD",
        patches = ["//third_party/sentencepiece:sentencepiece.patch"],
        patch_args = ["-p1"],
    )

    http_archive(
        name = "darts_clone",
        build_file = "//third_party/darts_clone:BUILD",
        sha256 = "c97f55d05c98da6fcaf7f9ecc6a6dc6bc5b18b8564465f77abff8879d446491c",
        strip_prefix = "darts-clone-e40ce4627526985a7767444b6ed6893ab6ff8983",
        urls = [
            "https://github.com/s-yata/darts-clone/archive/e40ce4627526985a7767444b6ed6893ab6ff8983.zip",
        ],
    )

    http_archive(
        name = "com_google_glog",
        sha256 = "1ee310e5d0a19b9d584a855000434bb724aa744745d5b8ab1855c85bff8a8e21",
        strip_prefix = "glog-028d37889a1e80e8a07da1b8945ac706259e5fd8",
        urls = [
            "https://mirror.bazel.build/github.com/google/glog/archive/028d37889a1e80e8a07da1b8945ac706259e5fd8.tar.gz",
            "https://github.com/google/glog/archive/028d37889a1e80e8a07da1b8945ac706259e5fd8.tar.gz",
        ],
    )

    # ==== TensorFlow Decision Forests ===
    http_archive(
        name = "org_tensorflow_decision_forests",
        sha256 = "00c73fbb1ddde7f11fbb5277e9cc9a0922b5f1213c6bd1038769ee451be4ba87",
        strip_prefix = "decision-forests-1.1.0",
        url = "https://github.com/tensorflow/decision-forests/archive/refs/tags/1.1.0.zip",
    )

    http_archive(
        name = "ydf",
        sha256 = "8d577e2628201ec2a2c1708192a23e5b34a2fcc126b6e043fef613886857c9a6",
        strip_prefix = "yggdrasil-decision-forests-1.2.0",
        urls = ["https://github.com/google/yggdrasil-decision-forests/archive/refs/tags/1.2.0.zip"],
    )

    # The Boost repo is organized into git sub-modules (see the list at
    # https://github.com/boostorg/boost/tree/master/libs), which requires "new_git_repository".
    #new_git_repository(
    #    name = "org_boost",
    #    commit = "b7b1371294b4bdfc8d85e49236ebced114bc1d8f",  # boost-1.75.0
    #    build_file = "//third_party/boost:BUILD",
    #    init_submodules = True,
    #    recursive_init_submodules = True,
    #    remote = "git@github.com:boostorg/boost.git",
    #)
    
    native.new_local_repository(
        name = "org_boost",
        path = "deps/boost",
        build_file = "//third_party/boost:BUILD",
    )