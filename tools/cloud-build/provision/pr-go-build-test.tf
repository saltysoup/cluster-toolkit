# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


resource "google_cloudbuild_trigger" "pr_go_build_test" {
  # NOTE: make sure that go.mod:go and Makefile:MIN_GOLANG_VERSION match lowest version.
  for_each = toset(["1.23", "1.24"])

  name        = "PR-Go-${replace(each.key, ".", "-")}-build-test"
  description = "Test that the PR builds with Go ${each.key}"

  build {
    step {
      name       = "golang:${each.key}"
      entrypoint = "/bin/bash"
      args       = ["-c", "make ghpc test-engine"]
    }
  }

  github {
    owner = "GoogleCloudPlatform"
    name  = "cluster-toolkit"
    pull_request {
      branch          = ".*"
      comment_control = "COMMENTS_ENABLED_FOR_EXTERNAL_CONTRIBUTORS_ONLY"
    }
  }
  include_build_logs = "INCLUDE_BUILD_LOGS_WITH_STATUS"
}
