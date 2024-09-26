## Overview

<!-- Sensu Integration description; supports markdown -->

The Etcd Metrics integration collects metrics from hosts running [etcd] and outputs the metrics in Prometheus format.

<!-- Provide a high level overview of the integration contents (e.g. checks, filters, mutators, handlers, assets, etc) -->

This integration includes the following Sensu resources:

* `etcd-metrics` [check]
* `sensu/http-checks:0.7.0` [asset]

## Dashboards

<!-- List of compatible dashboards w/ screenshots (supports png, jpeg, and gif images; relative paths only; e.g. `![](img/dashboard-1.png)` )-->

<!-- This integration is compatible with the [{{dashboard_name}}][{{dashboard_link}}] (included w/ [Sensu Plus][sensu-plus]). -->

<!-- ![](img/dashboard.png) -->

The Etcd Metrics integration does not have compatible dashboards.

## Setup

<!-- Sensu Integration setup instructions, including Sensu agent configuration and external component configuration -->
<!-- EXAMPLE: what configuration (if any) is required in a third-party service to enable monitoring? -->

1. Get the etcd `/metrics` endpoint target URL. You will need these target URL elements to install this integration:

   - Protocol (`http` or `https`)
   - Host (hostname, IP address, or domain name)
   - Port number (etcd's default is `2379`)
   - Path (`/metrics`)

1. Decide which Sensu agents should execute the `etcd-metrics` check. You will need the agent [subscription] names when you install this integration.

1. If you want to use a Sensu [pipeline] to process Etcd Metrics integration data, you will need the pipeline names when you install this integration.

   You can configure separate pipelines for alerts, incident management, and metrics.

1. **Optional** Configure custom request headers.

   To use custom request headers, install this integration. Then, update the `etcd-metrics` check to add one or more `--header` flags in the check's `command` attribute.

   <details><summary><strong>Example: Custom request header configuration</strong></summary>

   ```yaml
   spec:
     command: >-
       http-get
       --timeout 10
       --url "http://127.0.0.1:2379/metrics"
       --header "Content-Type: text/plain"
       --header "X-Example-Header: helloworld"
   ```

   </details>
   <br>

## Plugins

<!-- Links to any Sensu Integration dependencies (i.e. Sensu Plugins) -->

The Etcd Metrics integration uses the following Sensu [plugins]:

- [sensu/http-checks][http-checks-bonsai] ([GitHub][http-checks-github])

## Alerts

The Etcd Metrics integration produces the following alerts.

**etcd_server_has_leader** (Boolean)

Generates a CRITICAL event if etcd does not have a leader.

## Metrics

<!-- List of all metrics or events collected by this integration. -->

The Etcd Metrics integration collects many [metrics]. For a complete list of metrics, read the [Metrics page] in the etcd documentation.

## Reference Documentation

<!-- Please provide links to any relevant reference documentation to help users learn more and/or troubleshoot this integration; specifically including any third-party software documentation. -->

* [Token substitution] (Sensu documentation): the Etcd Metrics integration supports Sensu tokens for variable substitution with data from Sensu entities
* [Metrics][Metrics page] (etcd documentation)


<!-- Links -->
[entity]: https://docs.sensu.io/sensu-go/latest/observability-pipeline/observe-entities/entities/
[check]: https://docs.sensu.io/sensu-go/latest/observability-pipeline/observe-schedule/checks/
[asset]: https://docs.sensu.io/sensu-go/latest/plugins/assets/
[subscription]: https://docs.sensu.io/sensu-go/latest/observability-pipeline/observe-schedule/subscriptions/
[subscriptions]: https://docs.sensu.io/sensu-go/latest/observability-pipeline/observe-schedule/subscriptions/
[agents]: https://docs.sensu.io/sensu-go/latest/observability-pipeline/observe-schedule/agent/
[annotation]: https://docs.sensu.io/sensu-go/latest/observability-pipeline/observe-schedule/agent/#agent-annotations
[plugins]: https://docs.sensu.io/sensu-go/latest/plugins/
[metrics]: https://docs.sensu.io/sensu-go/latest/observability-pipeline/observe-schedule/metrics/
[handler]: https://docs.sensu.io/sensu-go/latest/observability-pipeline/observe-process/handlers/
[pipeline]: https://docs.sensu.io/sensu-go/latest/observability-pipeline/observe-process/pipelines/
[secret]: https://docs.sensu.io/sensu-go/latest/operations/manage-secrets/secrets/
[secrets]: https://docs.sensu.io/sensu-go/latest/operations/manage-secrets/secrets/
[tokens]: https://docs.sensu.io/sensu-go/latest/observability-pipeline/observe-schedule/tokens/
[sensu-plus]: https://sensu.io/features/analytics
[http-checks-bonsai]: https://bonsai.sensu.io/assets/sensu/http-checks
[http-checks-github]: https://github.com/sensu/http-checks
[etcd]: https://etcd.io/
[Metrics page]: https://etcd.io/docs/latest/metrics/
