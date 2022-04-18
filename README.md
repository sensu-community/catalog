# Sensu Integration Catalog

This repository contains [monitoring as code][mac] templates for enabling various
monitoring integrations (e.g. Linux system monitoring checks, or NGINX service
health monitoring), and pipeline integrations (e.g. Pagerduty, Elasticsearch,
Splunk, Ansible Tower).

- [Project Goals](#project-goals)
- [Sensu Integration Specification](#sensu-integration-specification)
  - [Integration directory structure](#integration-directory-structure)
  - [Integration API specification](#integration-api-specification)
- [Sensu Integration Guidelines](#sensu-integration-guidelines)
  - [CheckConfig guidelines](#checkconfig-guidelines)
  - [Pipeline guidelines](#pipeline-guidelines)
  - [Asset guidelines](#asset-guidelines)
- [Contributing](#contributing)

## Project Goals

The goal of this project is to provide reference implementations for effective
monitoring with Sensu Go. The Sensu Catalog should (eventually) provide
everything a new Sensu user needs to get up and running and rapidly deploy
across a large fleet of systems.

## Sensu Integration Specification

A Sensu Catalog is a collection of Sensu Integrations.
The contents of this catalog are periodically published to the official [Sensu Catalog API][catalog-api], which is hosted at https://catalog.sensu.io.

See below for individual [integration contents](#integration-directory-structure) and [API specification](#integration-api-specification).

### Integration directory structure

Sensu Integrations are defined as files on disk in the following structure:

```
integrations/
└── <namespace; e.g. "nginx">/
    └── <integration; e.g. "nginx-healthcheck">/
        ├── img/
        │   ├── dashboard-1.gif
        │   └── dashboard-2.png
        ├── CHANGELOG.md
        ├── README.md
        ├── logo.png
        ├── sensu-integration.yaml
        └── sensu-resources.yaml
```

* **`sensu-resources.yaml`**

  Sensu API resources to be applied/installed by the integration including Checks, Handlers, Assets, and more.
  All resources _must_ be in YAML format, for consistency and comment support.
  All YAML files should use the `.yaml` file extension (not `.yml`), because we're picky that way.

* **`sensu-integration.yaml`**

  Sensu Integration metadata, including integration title and description.
  All integration _must_ be in YAML format, for consistency and comment support.
  All YAML files should use the `.yaml` file extension (not `.yml`), because we're picky that way.

* **`logo.png`**

  Sensu Integration logo to be displayed in the in-app integration browser.

* **`README.md`**

  Sensu Integration documentation, including overview, setup, and links to supplemental reference documentation.
  _NOTE: Sensu Integrations READMEs support [GitHub-flavored Markdown][github-md]._

* **`CHANGELOG.md`**

  Sensu Integration changelog (optional & not currently used by the in-app browser).

* **`img/`**

  Supplemental image contents (for use in README.md).
  _NOTE: only JPEG, PNG, and GIF images in the `img/` subdirectory are supported (external image links are not supported)._

### Integration API specification

Sensu Integrations resemble Sensu Go API resources, but they are _not_ processed by Sensu Go directly.
See the [[sensu/catalog-api]][catalog-api] project for more information.

**Example:**

```yaml
---
api_version: catalog/v1
type: Integration
metadata:
  namespace: nginx
  name: nginx-healthcheck
spec:
  class: "supported"
  provider: "monitoring"
  display_name: "NGINX monitoring"
  short_description: NGINX service health and performance monitoring
  supported_platforms:
    - linux
    - windows
    - darwin
  tags:
    - http
    - nginx
    - webserver
  contributors:
    - @sensu
    - @calebhailey
    - @jspaleta
    - @thoward
  prompts:
    - type: question
      name: url
      required: false
      input:
        type: string
        title: Default URL
        description: >-
          What is the default `nginx_status` endpoint URL that should be used?
        format: url
        default: http://127.0.0.1:80/nginx_status
    - type: question
      name: interval
      required: false
      input:
        type: integer
        title: Interval
        description: >-
          How often (in seconds) do you want to check the status of NGINX?
        format: duration
        default: 30
    - type: section
      title: Pipeline Configuration
    - type: markdown
      body: |
        Configure one or more [pipelines] for processing NGINX monitoring data.

        [pipelines]: https://docs.sensu.io/sensu-go/latest/observability-pipeline/
    - type: question
      name: metrics_pipeline
      required: false
      input:
        type: string
        title: Metrics Pipeline
        description: >-
          How do you want to process metrics collected by this integration?
        ref: core/v2/pipeline/metadata/name
        refFilter: .labels.provider == "metrics"
    - type: question
      name: alert_pipeline
      required: false
      input:
        type: string
        title: Alert Pipeline
        description: >-
          How do you want to be alerted for failures detected by this pipeline (e.g. Slack or Microsoft Teams)?
        ref: core/v2/pipeline/metadata/name
        refFilter: .labels.provider == "alerts"
    - type: question
      name: incident_pipeline
      required: false
      input:
        type: string
        title: Incident Management Pipeline
        description: >-
          How do you want to process incidents for failures detected by this pipeline (e.g. Atlassian JIRA/ServiceDesk, or Pagerduty)?
        ref: core/v2/pipeline/metadata/name
        refFilter: .labels.provider == "incidents"
  resource_patches:
    - resource:
        type: CheckConfig
        api_version: core/v2
        name: nginx-healthcheck
      patches:
        - path: /metadata/name
          op: replace
          value: nginx-healthcheck-[[auto_suffix]]
        - path: /spec/interval
          op: replace
          value: interval
        - path: /spec/command
          op: replace
          value: >-
            check-nginx-status.rb
            --url {{ .annotations.check_nginx_status_url | default "[[url]]" }}
        - path: /spec/pipelines/-
          op: add
          value:
            api_version: "core/v2"
            type: "Pipeline"
            name: "[[metrics_pipeline]]"
        - path: /spec/pipelines/-
          op: add
          value:
            api_version: "core/v2"
            type: "Pipeline"
            name: "[[alert_pipeline]]"
        - path: /spec/pipelines/-
          op: add
          value:
            api_version: "core/v2"
            type: "Pipeline"
            name: "[[incident_pipeline]]"
```

* `class`

  Integration class. Must be one of the following values:

  * `community`
  * `supported` (first-party catalog templates)
  * `enterprise` (first-party catalog templates that require a valid license)
  * `partner` (third-party catalog templates)

* `provider`

  Integration provider. Must be one of the following values:

  * `monitoring`
  * `discovery`
  * `alerts`
  * `incidents`
  * `metrics`
  * `events`
  * `deregistration`
  * `remediation`

* `display_name`

  Integration display name (e.g. "Pagerduty Incidents"), displayed as the integration name in the in-app integration browser.

* `short_description`

  Integration short description (e.g. "Create and resolve incidents with Pagerduty"), displayed in the in-app integration browser on hover.

* `supported_platforms`

  Used for checks only.

* `tags`

  List of tags (e.g. keywords). Used for integration filtering.

* `contributors`

  List of GitHub @usernames. To be displayed on integration detail pages.

* `prompts`

  Used to configure user-provided variables for use in `resource_patches`. Prompts can be composed from the following "blocks": `type:question`, `type:section`, and `type:markdown`.

  **Examples**:

  * `type:question`

    Used to collect user input.

    **Example:**

    ```yaml
    prompts:
      - type: question
        name: var1
        required: false
        input:
          type: int
          title: Check Interval
          description: >-
            How often do you want to check the service health?
          format: duration
          default: 30
      - type: question
        name: var2
        required: true
        input:
          type: string
          title: Alert Pipeline
          description: >-
            How do you want to be alerted for failures detected by this pipeline (e.g. Slack or Microsoft Teams)?
          ref: core/v2/pipeline/metadata/name
          refFilter: .labels.provider == "alerts"
    ```

    The following `input` fields may be configured:

    * **`type`** (required): data type; allowed values: `string`, `int`, `bool`.
    * **`name`** (required): variable name to be used in `resource_patches` templates.
    * **`required`** (required): indicates whether a user-input is required.
    * **`input.title`** (required): input field title/label, displayed above the input field.
    * **`input.description`** (optional): input field description, displayed below the input field.
    * **`input.format`** (optional): input value display format; allowed values: `sh`, `ecmascript-5.1`, `cron`, `duration`, `tel`, `email`, `url`, `hostname`, `ipv4`, `ipv6`, `envvar`, `sha-256`, `sha-512`, `io.sensu.selector`. Some display formats provide helpers to simplify user input.
    * **`input.ref`** (optional): Sensu API resource reference in `<api_group>/<api_resource>/<api_field_path>` format. For example, `core/v2/Pipeline/metadata/name` refers to `core/v2` API group `Pipeline` resources, which will be presented to the user in a drop-down selector; once selected, the value of the `metadata/name` field will be captured as the input value.
    * **`input.refFilter`** (coming soon): Sensu API resource reference filters in [Sensu Query Expression (SQE)] format; e.g. `.labels.provider == "alerts"`. Used to filter the results of a `ref`.

  * `type:section`

    Used to split user-prompts into logical groupings. Typically used in conjunction with a `type:markdown` block.

    ```yaml
    prompts:
      - type: section
        title: Configuration
    ```

  * `type:markdown`

    Used to provide inline documentation in the user prompt dialogs.

    ```yaml
    prompts:
      - type: markdown
        body: |
          Hello, **inline documentation**. Use markdown blocks to provide users with additional context or instructions.

          Markdown content can include code blocks.

          **Example**

          ```json
          {
            "foo": "bar"
          }
          ```
    ```

* `resource_patches`

  Changes to apply to the Integration's Sensu Resources (i.e. `sensu-resources.yaml`). Resource patches are defined via two properties: a `resource` identifier, and a list of `patches`.

  * `resource`

    A Sensu API resource identifier. The resource identifier will be used to select a resource defined in `sensu-resources.yaml`.

    **Example**:

    ```yaml
    resource:
      api_version: core/v2
      type: CheckConfig
      name: helloworld
    ```

  * `patches`

    A list of updates to apply to the selected resource, in [JSON Patch] format.
    Variable substitution is supported via `varname` references.
    Templating is supported via double square bracket references (e.g. `Hello, [[varname]]`).
    All patches must specific a `path`, `op` (operation), and a `value`.

    If an individual operation fails, it will be considered as optional and skipped.

    **Example**:

    ```yaml
    patches:
      - path: /spec/pipelines/-
        op: add
        value:
    ```

    **Fields**:

    * `path`

      Used to select a JSON field, in [JSON Pointer] format. JSON Pointer paths support array indexes (e.g. `/spec/subscriptions/0`), and `-` may be used to insert values at the end of an array (e.g. `/spec/subscriptions/-`).

      **Example**:

      ```json
      {
        "api_version": "",
        "type": "CheckConfig",
        "metadata": {
          "name": "helloworld"
        },
        "spec": {
          "command": "helloworld.sh",
          "runtime_assets": []
        }
      }
      ```

      In the above example, the `command` field would be accessed via the [JSON Pointer] path: `/spec/command`.

    * `op`

      The patch operation to perform. The currently supported operations are [`add`][jsonpatch_add] and [`replace`][jsonpatch_replace].

      _NOTE: [JSON Patch] supports `add`, `remove`, `replace`, `copy`, and `move` operations, so additional operations may be supported in the future._

    * `value`

      The value to be applied in the patch.
      Variable substitution is supported via `varname` references (i.e. double square brackets).
      Please note the following details about Integration variables:

      * Sensu Integration variables have a name (e.g. `team`, or `interval`) and data type (e.g. `string`, `int`).
      * Sensu Integration variables can be used as Sensu Integration `resource_patch` values (e.g. `value: interval`).
      * Sensu Integration variable can be interpolated into a string template via double square brackets (e.g. `Hello, [[ team ]]`).
      * Available variables:
        * A built-in variable named **`auto_suffix`**: randomly generated 8-digit hexadecimal string value (e.g. `168c41a1`).
        * **User-provided variables**: supplied via a user `prompt` (see the `name` field of any `type:question` prompt).

### Sensu Integration guidelines

Please note the following guidelines for composing Sensu Integration:

1. **YAML format**. All integration metadata (`sensu-integration.yaml`) and resources (`sensu-resources.yaml`) _must_ be in YAML format, for consistency and comment support.
   All YAML files should use the `.yaml` file extension (not `.yml`), because we're picky that way.

1. **Namespace templating**. Resource definitions (`sensu-resources.yaml`) _should not_ include a namespace.

1. **Linting**. All integrations will be validated via [super-linter][linter].
   We recommend [running it locally][linter-local] to streamline PR approval.

1. **Naming conflicts**. CheckConfig, HookConfig, Filter, Mutator, and Handler resource names _must_ be unique within the scope of this project.

   _NOTE: at this time we do not wish to enforce strict naming conventions.
   We will resolve naming conflicts on a case-by-case basis, which means resource names will be subject to change._

## Sensu Integration Guidelines

#### CheckConfig guidelines

1. Check templates resources _should_ be defined in the following order (by
   resource type):

   * CheckConfig
   * HookConfig(s)
   * Secret(s)
   * Asset(s)

1. Check resources _must_ recommend one or more named subscriptions.
   At a minimum this should include the corresponding integrations "namespace" (sub-directory) as the default naming convention.
   For example, all PostgreSQL monitoring templates should include the ["postgres"](integrations/postgres) subscription.
   Check resources may optionally include additional/alternate subscription names (e.g. "pg" or "postgresql").

1. The `command` field _should_ preferably be wrapped using the [YAML `>-` multiline "block scalar" syntax][yaml-multiline] for readability.

   ```yaml
   spec:
     command: >-
       check-disk-usage.rb
       -w {{ .annotations.disk_usage_warning | default 85 }}
       -c {{ .annotations.disk_usage_critical | default 95 }}
   ```

1. As shown in the example above, check commands should include tunables using [Sensu tokens][tokens], preferably sourced from Entity **annotations** (not labels) with explicitly configured defaults.

1. Check resources _should_ use the "interval" scheduler, with a minimum interval of `30` seconds.

1. Check timeout _should_ be set to a non-zero value and should not be greater than 50% of the interval.

1. Check pipelines _should_ be configured to one of the following generic pipelines.

   - `alert` (e.g. Slack, Mattermost, Microsoft Teams)
   - `incident-management` (e.g. Pagerduty, ServiceNow)
   - `metrics` (e.g. Sumo Logic, InfluxDB, TimescaleDB, Prometheus)
   - `events` (e.g. Sumo Logic, Elasticsearch, Splunk)
   - `deregistration` (e.g. Chef, Puppet, Ansible, EC2)
   - `remediation` (e.g. Ansible Tower, Rundeck, SaltStack)

#### Pipeline guidelines

1. Pipeline template resources should be defined in the following order
   (by resource type):

   * Pipeline
   * Handler(s), SumoLogicMetricsHandler(s), and/or TCPStreamHandler(s)
   * Filter(s)
   * Mutator(s)
   * Secret(s)
   * Asset(s)

1. For alert and incident-management handlers avoid the use of filters that have highly subjective configuration options.
   By default, use the built-in `is_incident` and `not_silenced` filters.
   However, we do encourage you to share your filters, as appropriate in the `shared` directory.

#### Asset guidelines

1. Asset resources and their corresponding `runtime_assets` references _must_ include a version reference in their resource name.
   For example: `sensu/system-check:0.5.0`.

1. Asset resources _should_ include an organization or author the resource name.
   For example, the official Sensu Pagerduty plugin hosted in the "sensu" organization on GitHub ([sensu/sensu-pagerduty-handler][pagerduty-plugin]), and published to under the "sensu" organization on Bonsai ([sensu/sensu-pagerduty-handler][pagerduty-bonsai]) should be named: `sensu/sensu-pagerduty-handler:2.1.0`.

1. All [Sensu Assets][assets] resources must refer to assets hosted on [Bonsai][bonsai].

## Contributing

There are three ways to contribute to this project:

1. **Use the integration templates provided in this catalog and share your feedback.**

1. **Contribute "feature requests" to indicate interest in adding new integration templates.**

1. **Contribute integration templates and/or modifications to existing templates.**

How to do it:

- Integration feedback in the form of GitHub issues with titles like "Ansible
  Tower integration feedback" are welcome! Comments telling us what did 🙌 or
  didn't 🤔 work for you and/or any suggestions you might have are very
  helpful!

- Feature requests in the form of GitHub issues with titles like "Add support
  for X" are welcome! If such an issue already exists, a simple comment with
  a 👍 or 💯 emoji on an existing issue actually motivates us quite a bit more
  than you might think!

- **Pull requests are not only appreciated, they will be rewarded with [FREE
  SWAG][rewards]!** PRs that expose an implicit default configuration settings,
  or improve an integration template's code comments (documentation) will
  always be accepted. PRs that provide alternative configurations are also
  **always welcome**.

Thanks in advance for your contributions!

[mac]: #monitoring-as-code
[catalog-api]: https://github.com/sensu/catalog-api
[rewards]: https://sensu.io/contributor-rewards
[bonsai]: https://bonsai.sensu.io
[assets]: https://docs.sensu.io/sensu-go/latest/plugins/assets/
[tokens]: https://docs.sensu.io/sensu-go/latest/observability-pipeline/observe-schedule/tokens/
[linter]: https://github.com/github/super-linter/
[linter-local]: https://github.com/github/super-linter/blob/master/docs/run-linter-locally.md
[github-md]: https://github.github.com/gfm/
[yaml-multiline]: https://yaml-multiline.info
[pagerduty-plugin]: https://github.com/sensu/sensu-pagerduty-handler
[pagerduty-bonsai]: https://bonsai.sensu.io/assets/sensu/sensu-pagerduty-handler
[JSON Patch]: http://jsonpatch.com
[JSON Pointer]: http://jsonpatch.com/#json-pointer
[jsonpatch_add]: http://jsonpatch.com/#add
[jsonpatch_replace]: http://jsonpatch.com/#replace
[Sensu Query Expression (SQE)]: https://docs.sensu.io/sensu-go/latest/observability-pipeline/observe-filter/sensu-query-expressions/
