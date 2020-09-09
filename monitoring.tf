resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "prometheus" {
  chart      = "prometheus"
  name       = "prometheus"
  namespace  = kubernetes_namespace.monitoring.metadata.0.name
  timeout    = 1200
  repository = "https://kubernetes-charts.storage.googleapis.com"
  version    = "11.7.0"
}

resource "helm_release" "grafana" {
  chart      = "grafana"
  name       = "grafana"
  namespace  = kubernetes_namespace.monitoring.metadata.0.name
  timeout    = 1200
  repository = "https://kubernetes-charts.storage.googleapis.com"
  version    = "5.4.1"
  values = [<<EOF
---
adminUser: admin
adminPassword: admin
datasources:
  datasources.yaml:
    apiVersion: 1
    datasources:
    - name: Prometheus
      type: prometheus
      url: http://prometheus-server.${kubernetes_namespace.monitoring.metadata.0.name}.svc.cluster.local
      isDefault: true
dashboards:
  default:
    kubernetes:
      gnetId: 315
      revision: 3
      datasource: Prometheus
    prometheus-stats:
      gnetId: 3662
      revision: 2
      datasource: Prometheus
    velero:
      gnetId: 11055
      revision: 2
      datasource: Prometheus
    etcd:
      json: |
        {
          "annotations": {
            "list": [
              {
                "builtIn": 1,
                "datasource": "-- Grafana --",
                "enable": true,
                "hide": true,
                "iconColor": "rgba(0, 211, 255, 1)",
                "name": "Annotations & Alerts",
                "type": "dashboard"
              }
            ]
          },
          "description": "Etcd Dashboard for Prometheus metrics scraper",
          "editable": true,
          "gnetId": 3070,
          "graphTooltip": 0,
          "links": [],
          "panels": [
            {
              "cacheTimeout": null,
              "colorBackground": false,
              "colorValue": true,
              "colors": [
                "rgba(245, 54, 54, 0.9)",
                "rgba(237, 129, 40, 0.89)",
                "rgba(50, 172, 45, 0.97)"
              ],
              "datasource": "Prometheus",
              "fieldConfig": {
                "defaults": {
                  "custom": {}
                },
                "overrides": []
              },
              "format": "none",
              "gauge": {
                "maxValue": 100,
                "minValue": 0,
                "show": false,
                "thresholdLabels": false,
                "thresholdMarkers": true
              },
              "gridPos": {
                "h": 7,
                "w": 8,
                "x": 0,
                "y": 0
              },
              "id": 44,
              "interval": null,
              "links": [],
              "mappingType": 1,
              "mappingTypes": [
                {
                  "name": "value to text",
                  "value": 1
                },
                {
                  "name": "range to text",
                  "value": 2
                }
              ],
              "maxDataPoints": 100,
              "nullPointMode": "connected",
              "nullText": null,
              "postfix": "",
              "postfixFontSize": "50%",
              "prefix": "",
              "prefixFontSize": "50%",
              "rangeMaps": [
                {
                  "from": "null",
                  "text": "N/A",
                  "to": "null"
                }
              ],
              "sparkline": {
                "fillColor": "rgba(31, 118, 189, 0.18)",
                "full": false,
                "lineColor": "rgb(31, 120, 193)",
                "show": false
              },
              "tableColumn": "",
              "targets": [
                {
                  "expr": "max(etcd_server_has_leader)",
                  "format": "time_series",
                  "intervalFactor": 2,
                  "refId": "A",
                  "step": 600
                }
              ],
              "thresholds": "0,1",
              "title": "Etcd has a leader?",
              "type": "singlestat",
              "valueFontSize": "80%",
              "valueMaps": [
                {
                  "op": "=",
                  "text": "YES",
                  "value": "1"
                },
                {
                  "op": "=",
                  "text": "NO",
                  "value": "0"
                }
              ],
              "valueName": "avg"
            },
            {
              "cacheTimeout": null,
              "colorBackground": false,
              "colorValue": false,
              "colors": [
                "rgba(245, 54, 54, 0.9)",
                "rgba(237, 129, 40, 0.89)",
                "rgba(50, 172, 45, 0.97)"
              ],
              "datasource": "Prometheus",
              "fieldConfig": {
                "defaults": {
                  "custom": {}
                },
                "overrides": []
              },
              "format": "none",
              "gauge": {
                "maxValue": 100,
                "minValue": 0,
                "show": false,
                "thresholdLabels": false,
                "thresholdMarkers": true
              },
              "gridPos": {
                "h": 7,
                "w": 8,
                "x": 8,
                "y": 0
              },
              "id": 42,
              "interval": null,
              "links": [],
              "mappingType": 1,
              "mappingTypes": [
                {
                  "name": "value to text",
                  "value": 1
                },
                {
                  "name": "range to text",
                  "value": 2
                }
              ],
              "maxDataPoints": 100,
              "nullPointMode": "connected",
              "nullText": null,
              "postfix": "",
              "postfixFontSize": "50%",
              "prefix": "",
              "prefixFontSize": "50%",
              "rangeMaps": [
                {
                  "from": "null",
                  "text": "N/A",
                  "to": "null"
                }
              ],
              "sparkline": {
                "fillColor": "rgba(31, 118, 189, 0.18)",
                "full": false,
                "lineColor": "rgb(31, 120, 193)",
                "show": false
              },
              "tableColumn": "",
              "targets": [
                {
                  "expr": "max(etcd_server_leader_changes_seen_total)",
                  "format": "time_series",
                  "intervalFactor": 2,
                  "refId": "A",
                  "step": 600
                }
              ],
              "thresholds": "",
              "title": "The number of leader changes seen",
              "type": "singlestat",
              "valueFontSize": "80%",
              "valueMaps": [
                {
                  "op": "=",
                  "text": "N/A",
                  "value": "null"
                }
              ],
              "valueName": "avg"
            },
            {
              "cacheTimeout": null,
              "colorBackground": false,
              "colorValue": false,
              "colors": [
                "rgba(245, 54, 54, 0.9)",
                "rgba(237, 129, 40, 0.89)",
                "rgba(50, 172, 45, 0.97)"
              ],
              "datasource": "Prometheus",
              "fieldConfig": {
                "defaults": {
                  "custom": {}
                },
                "overrides": []
              },
              "format": "none",
              "gauge": {
                "maxValue": 100,
                "minValue": 0,
                "show": false,
                "thresholdLabels": false,
                "thresholdMarkers": true
              },
              "gridPos": {
                "h": 7,
                "w": 8,
                "x": 16,
                "y": 0
              },
              "id": 43,
              "interval": null,
              "links": [],
              "mappingType": 1,
              "mappingTypes": [
                {
                  "name": "value to text",
                  "value": 1
                },
                {
                  "name": "range to text",
                  "value": 2
                }
              ],
              "maxDataPoints": 100,
              "nullPointMode": "connected",
              "nullText": null,
              "postfix": "",
              "postfixFontSize": "50%",
              "prefix": "",
              "prefixFontSize": "50%",
              "rangeMaps": [
                {
                  "from": "null",
                  "text": "N/A",
                  "to": "null"
                }
              ],
              "sparkline": {
                "fillColor": "rgba(31, 118, 189, 0.18)",
                "full": false,
                "lineColor": "rgb(31, 120, 193)",
                "show": false
              },
              "tableColumn": "",
              "targets": [
                {
                  "expr": "max(etcd_server_leader_changes_seen_total)",
                  "format": "time_series",
                  "intervalFactor": 2,
                  "refId": "A",
                  "step": 600
                }
              ],
              "thresholds": "",
              "title": "The total number of failed proposals seen",
              "type": "singlestat",
              "valueFontSize": "80%",
              "valueMaps": [
                {
                  "op": "=",
                  "text": "N/A",
                  "value": "null"
                }
              ],
              "valueName": "avg"
            },
            {
              "aliasColors": {},
              "bars": false,
              "dashLength": 10,
              "dashes": false,
              "datasource": "Prometheus",
              "editable": true,
              "error": false,
              "fieldConfig": {
                "defaults": {
                  "custom": {}
                },
                "overrides": []
              },
              "fill": 0,
              "fillGradient": 0,
              "gridPos": {
                "h": 7,
                "w": 9,
                "x": 0,
                "y": 7
              },
              "hiddenSeries": false,
              "id": 47,
              "legend": {
                "avg": false,
                "current": false,
                "max": false,
                "min": false,
                "show": true,
                "total": false,
                "values": false
              },
              "lines": true,
              "linewidth": 2,
              "links": [],
              "nullPointMode": "null",
              "options": {
                "dataLinks": []
              },
              "percentage": false,
              "pointradius": 5,
              "points": false,
              "renderer": "flot",
              "seriesOverrides": [],
              "spaceLength": 10,
              "stack": false,
              "steppedLine": false,
              "targets": [
                {
                  "expr": "avg by (pod) (container_memory_working_set_bytes{container=\"etcd\"}) / sum by (pod) (kube_pod_container_resource_limits_memory_bytes{container=\"etcd\"})",
                  "format": "time_series",
                  "hide": false,
                  "interval": "",
                  "intervalFactor": 2,
                  "legendFormat": "",
                  "metric": "process_resident_memory_bytes",
                  "refId": "A",
                  "step": 120
                }
              ],
              "thresholds": [],
              "timeFrom": null,
              "timeRegions": [],
              "timeShift": null,
              "title": "Memory Limit %",
              "tooltip": {
                "msResolution": false,
                "shared": true,
                "sort": 0,
                "value_type": "individual"
              },
              "type": "graph",
              "xaxis": {
                "buckets": null,
                "mode": "time",
                "name": null,
                "show": true,
                "values": []
              },
              "yaxes": [
                {
                  "$$hashKey": "object:329",
                  "format": "percentunit",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                },
                {
                  "$$hashKey": "object:330",
                  "format": "short",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                }
              ],
              "yaxis": {
                "align": false,
                "alignLevel": null
              }
            },
            {
              "aliasColors": {},
              "bars": false,
              "dashLength": 10,
              "dashes": false,
              "datasource": "Prometheus",
              "editable": true,
              "error": false,
              "fieldConfig": {
                "defaults": {
                  "custom": {}
                },
                "overrides": []
              },
              "fill": 0,
              "fillGradient": 0,
              "gridPos": {
                "h": 7,
                "w": 9,
                "x": 9,
                "y": 7
              },
              "hiddenSeries": false,
              "id": 29,
              "legend": {
                "avg": false,
                "current": false,
                "max": false,
                "min": false,
                "show": true,
                "total": false,
                "values": false
              },
              "lines": true,
              "linewidth": 2,
              "links": [],
              "nullPointMode": "null",
              "options": {
                "dataLinks": []
              },
              "percentage": false,
              "pointradius": 5,
              "points": false,
              "renderer": "flot",
              "seriesOverrides": [],
              "spaceLength": 10,
              "stack": false,
              "steppedLine": false,
              "targets": [
                {
                  "expr": "sum(rate(container_cpu_usage_seconds_total{name!~\".*prometheus.*\", image!=\"\", container=\"etcd\"}[5m])) by (pod, container) /\r\nsum(container_spec_cpu_quota{name!~\".*prometheus.*\", image!=\"\", container=\"etcd\"}/container_spec_cpu_period{name!~\".*prometheus.*\", image!=\"\", container=\"etcd\"}) by (pod, container)",
                  "format": "time_series",
                  "interval": "",
                  "intervalFactor": 2,
                  "legendFormat": "{{ pod }}",
                  "metric": "process_resident_memory_bytes",
                  "refId": "A",
                  "step": 120
                }
              ],
              "thresholds": [],
              "timeFrom": null,
              "timeRegions": [],
              "timeShift": null,
              "title": "CPU Limit %",
              "tooltip": {
                "msResolution": false,
                "shared": true,
                "sort": 0,
                "value_type": "individual"
              },
              "type": "graph",
              "xaxis": {
                "buckets": null,
                "mode": "time",
                "name": null,
                "show": true,
                "values": []
              },
              "yaxes": [
                {
                  "$$hashKey": "object:152",
                  "format": "percentunit",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                },
                {
                  "$$hashKey": "object:153",
                  "format": "short",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                }
              ],
              "yaxis": {
                "align": false,
                "alignLevel": null
              }
            },
            {
              "aliasColors": {},
              "bars": false,
              "dashLength": 10,
              "dashes": false,
              "datasource": "Prometheus",
              "editable": true,
              "error": false,
              "fieldConfig": {
                "defaults": {
                  "custom": {}
                },
                "overrides": []
              },
              "fill": 0,
              "fillGradient": 0,
              "gridPos": {
                "h": 7,
                "w": 6,
                "x": 18,
                "y": 7
              },
              "hiddenSeries": false,
              "id": 48,
              "legend": {
                "avg": false,
                "current": false,
                "max": false,
                "min": false,
                "show": true,
                "total": false,
                "values": false
              },
              "lines": true,
              "linewidth": 2,
              "links": [],
              "nullPointMode": "null",
              "options": {
                "dataLinks": []
              },
              "percentage": false,
              "pointradius": 5,
              "points": false,
              "renderer": "flot",
              "seriesOverrides": [],
              "spaceLength": 10,
              "stack": false,
              "steppedLine": false,
              "targets": [
                {
                  "expr": "sum by (pod) (container_cpu_cfs_throttled_periods_total{container=\"etcd\"} / container_cpu_cfs_periods_total{container=\"etcd\"})",
                  "format": "time_series",
                  "interval": "",
                  "intervalFactor": 2,
                  "legendFormat": "{{ pod }}",
                  "metric": "process_resident_memory_bytes",
                  "refId": "A",
                  "step": 120
                }
              ],
              "thresholds": [],
              "timeFrom": null,
              "timeRegions": [],
              "timeShift": null,
              "title": "CPU Throttling",
              "tooltip": {
                "msResolution": false,
                "shared": true,
                "sort": 0,
                "value_type": "individual"
              },
              "type": "graph",
              "xaxis": {
                "buckets": null,
                "mode": "time",
                "name": null,
                "show": true,
                "values": []
              },
              "yaxes": [
                {
                  "format": "percentunit",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                },
                {
                  "format": "short",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                }
              ],
              "yaxis": {
                "align": false,
                "alignLevel": null
              }
            },
            {
              "aliasColors": {},
              "bars": false,
              "dashLength": 10,
              "dashes": false,
              "datasource": "Prometheus",
              "decimals": null,
              "editable": true,
              "error": false,
              "fieldConfig": {
                "defaults": {
                  "custom": {}
                },
                "overrides": []
              },
              "fill": 0,
              "fillGradient": 0,
              "grid": {},
              "gridPos": {
                "h": 7,
                "w": 6,
                "x": 0,
                "y": 14
              },
              "hiddenSeries": false,
              "id": 1,
              "legend": {
                "avg": false,
                "current": false,
                "max": false,
                "min": false,
                "show": false,
                "total": false,
                "values": false
              },
              "lines": true,
              "linewidth": 2,
              "links": [],
              "nullPointMode": "connected",
              "options": {
                "dataLinks": []
              },
              "percentage": false,
              "pointradius": 5,
              "points": false,
              "renderer": "flot",
              "seriesOverrides": [],
              "spaceLength": 10,
              "stack": false,
              "steppedLine": false,
              "targets": [
                {
                  "expr": "etcd_debugging_mvcc_db_total_size_in_bytes",
                  "format": "time_series",
                  "hide": false,
                  "interval": "",
                  "intervalFactor": 2,
                  "legendFormat": "{{instance}} DB Size",
                  "metric": "",
                  "refId": "A",
                  "step": 120
                }
              ],
              "thresholds": [],
              "timeFrom": null,
              "timeRegions": [],
              "timeShift": null,
              "title": "DB Size",
              "tooltip": {
                "msResolution": false,
                "shared": true,
                "sort": 0,
                "value_type": "cumulative"
              },
              "type": "graph",
              "xaxis": {
                "buckets": null,
                "mode": "time",
                "name": null,
                "show": true,
                "values": []
              },
              "yaxes": [
                {
                  "format": "bytes",
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                },
                {
                  "format": "short",
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": false
                }
              ],
              "yaxis": {
                "align": false,
                "alignLevel": null
              }
            },
            {
              "aliasColors": {},
              "bars": false,
              "dashLength": 10,
              "dashes": false,
              "datasource": "Prometheus",
              "editable": true,
              "error": false,
              "fieldConfig": {
                "defaults": {
                  "custom": {}
                },
                "overrides": []
              },
              "fill": 0,
              "fillGradient": 0,
              "grid": {},
              "gridPos": {
                "h": 7,
                "w": 6,
                "x": 6,
                "y": 14
              },
              "hiddenSeries": false,
              "id": 3,
              "legend": {
                "avg": false,
                "current": false,
                "max": false,
                "min": false,
                "show": true,
                "total": false,
                "values": false
              },
              "lines": true,
              "linewidth": 2,
              "links": [],
              "nullPointMode": "connected",
              "options": {
                "dataLinks": []
              },
              "percentage": false,
              "pointradius": 1,
              "points": false,
              "renderer": "flot",
              "seriesOverrides": [],
              "spaceLength": 10,
              "stack": false,
              "steppedLine": true,
              "targets": [
                {
                  "expr": "histogram_quantile(0.99, sum(rate(etcd_disk_wal_fsync_duration_seconds_bucket[5m])) by (kubernetes_pod_name, le))",
                  "format": "time_series",
                  "hide": false,
                  "interval": "",
                  "intervalFactor": 2,
                  "legendFormat": "{{kubernetes_pod_name}} WAL fsync",
                  "metric": "etcd_disk_wal_fsync_duration_seconds_bucket",
                  "refId": "A",
                  "step": 120
                },
                {
                  "expr": "histogram_quantile(0.99, sum(rate(etcd_disk_backend_commit_duration_seconds_bucket[5m])) by (kubernetes_pod_name, le))",
                  "format": "time_series",
                  "interval": "",
                  "intervalFactor": 2,
                  "legendFormat": "{{kubernetes_pod_name}} DB fsync",
                  "metric": "etcd_disk_backend_commit_duration_seconds_bucket",
                  "refId": "B",
                  "step": 120
                }
              ],
              "thresholds": [],
              "timeFrom": null,
              "timeRegions": [],
              "timeShift": null,
              "title": "Disk Sync Duration",
              "tooltip": {
                "msResolution": false,
                "shared": true,
                "sort": 0,
                "value_type": "cumulative"
              },
              "type": "graph",
              "xaxis": {
                "buckets": null,
                "mode": "time",
                "name": null,
                "show": true,
                "values": []
              },
              "yaxes": [
                {
                  "format": "s",
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                },
                {
                  "format": "short",
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": false
                }
              ],
              "yaxis": {
                "align": false,
                "alignLevel": null
              }
            },
            {
              "aliasColors": {},
              "bars": false,
              "dashLength": 10,
              "dashes": false,
              "datasource": "Prometheus",
              "editable": true,
              "error": false,
              "fieldConfig": {
                "defaults": {
                  "custom": {}
                },
                "overrides": []
              },
              "fill": 0,
              "fillGradient": 0,
              "gridPos": {
                "h": 7,
                "w": 6,
                "x": 12,
                "y": 14
              },
              "hiddenSeries": false,
              "id": 20,
              "legend": {
                "avg": false,
                "current": false,
                "max": false,
                "min": false,
                "show": false,
                "total": false,
                "values": false
              },
              "lines": true,
              "linewidth": 2,
              "links": [],
              "nullPointMode": "connected",
              "options": {
                "dataLinks": []
              },
              "percentage": false,
              "pointradius": 5,
              "points": false,
              "renderer": "flot",
              "seriesOverrides": [],
              "spaceLength": 10,
              "stack": false,
              "steppedLine": false,
              "targets": [
                {
                  "expr": "sum(rate(etcd_network_peer_received_bytes_total[5m])) by (instance)",
                  "format": "time_series",
                  "intervalFactor": 2,
                  "legendFormat": "{{instance}} Peer Traffic In",
                  "metric": "etcd_network_peer_received_bytes_total",
                  "refId": "A",
                  "step": 120
                }
              ],
              "thresholds": [],
              "timeFrom": null,
              "timeRegions": [],
              "timeShift": null,
              "title": "Peer Traffic In",
              "tooltip": {
                "msResolution": false,
                "shared": true,
                "sort": 0,
                "value_type": "individual"
              },
              "type": "graph",
              "xaxis": {
                "buckets": null,
                "mode": "time",
                "name": null,
                "show": true,
                "values": []
              },
              "yaxes": [
                {
                  "format": "Bps",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                },
                {
                  "format": "short",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                }
              ],
              "yaxis": {
                "align": false,
                "alignLevel": null
              }
            },
            {
              "aliasColors": {},
              "bars": false,
              "dashLength": 10,
              "dashes": false,
              "datasource": "Prometheus",
              "decimals": null,
              "editable": true,
              "error": false,
              "fieldConfig": {
                "defaults": {
                  "custom": {}
                },
                "overrides": []
              },
              "fill": 0,
              "fillGradient": 0,
              "grid": {},
              "gridPos": {
                "h": 7,
                "w": 6,
                "x": 18,
                "y": 14
              },
              "hiddenSeries": false,
              "id": 16,
              "legend": {
                "avg": false,
                "current": false,
                "max": false,
                "min": false,
                "show": false,
                "total": false,
                "values": false
              },
              "lines": true,
              "linewidth": 2,
              "links": [],
              "nullPointMode": "connected",
              "options": {
                "dataLinks": []
              },
              "percentage": false,
              "pointradius": 5,
              "points": false,
              "renderer": "flot",
              "seriesOverrides": [],
              "spaceLength": 10,
              "stack": false,
              "steppedLine": false,
              "targets": [
                {
                  "expr": "sum(rate(etcd_network_peer_sent_bytes_total[5m])) by (instance)",
                  "format": "time_series",
                  "hide": false,
                  "interval": "",
                  "intervalFactor": 2,
                  "legendFormat": "{{instance}} Peer Traffic Out",
                  "metric": "etcd_network_peer_sent_bytes_total",
                  "refId": "A",
                  "step": 120
                }
              ],
              "thresholds": [],
              "timeFrom": null,
              "timeRegions": [],
              "timeShift": null,
              "title": "Peer Traffic Out",
              "tooltip": {
                "msResolution": false,
                "shared": true,
                "sort": 0,
                "value_type": "cumulative"
              },
              "type": "graph",
              "xaxis": {
                "buckets": null,
                "mode": "time",
                "name": null,
                "show": true,
                "values": []
              },
              "yaxes": [
                {
                  "format": "Bps",
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                },
                {
                  "format": "short",
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                }
              ],
              "yaxis": {
                "align": false,
                "alignLevel": null
              }
            },
            {
              "aliasColors": {},
              "bars": false,
              "dashLength": 10,
              "dashes": false,
              "datasource": "Prometheus",
              "editable": true,
              "error": false,
              "fieldConfig": {
                "defaults": {
                  "custom": {}
                },
                "overrides": []
              },
              "fill": 0,
              "fillGradient": 0,
              "gridPos": {
                "h": 7,
                "w": 12,
                "x": 0,
                "y": 21
              },
              "hiddenSeries": false,
              "id": 23,
              "legend": {
                "avg": false,
                "current": false,
                "max": false,
                "min": false,
                "show": false,
                "total": false,
                "values": false
              },
              "lines": true,
              "linewidth": 2,
              "links": [],
              "nullPointMode": "connected",
              "options": {
                "dataLinks": []
              },
              "percentage": false,
              "pointradius": 5,
              "points": false,
              "renderer": "flot",
              "seriesOverrides": [],
              "spaceLength": 10,
              "stack": false,
              "steppedLine": false,
              "targets": [
                {
                  "expr": "sum(rate(grpc_server_started_total{grpc_type=\"unary\"}[5m]))",
                  "format": "time_series",
                  "interval": "",
                  "intervalFactor": 2,
                  "legendFormat": "RPC Rate",
                  "metric": "grpc_server_started_total",
                  "refId": "A",
                  "step": 60
                },
                {
                  "expr": "sum(rate(grpc_server_handled_total{grpc_type=\"unary\",grpc_code!=\"OK\"}[5m]))",
                  "format": "time_series",
                  "interval": "",
                  "intervalFactor": 2,
                  "legendFormat": "RPC Failed Rate",
                  "metric": "grpc_server_handled_total",
                  "refId": "B",
                  "step": 60
                }
              ],
              "thresholds": [],
              "timeFrom": null,
              "timeRegions": [],
              "timeShift": null,
              "title": "RPC Rate",
              "tooltip": {
                "msResolution": false,
                "shared": true,
                "sort": 0,
                "value_type": "individual"
              },
              "type": "graph",
              "xaxis": {
                "buckets": null,
                "mode": "time",
                "name": null,
                "show": true,
                "values": []
              },
              "yaxes": [
                {
                  "format": "ops",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                },
                {
                  "format": "short",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                }
              ],
              "yaxis": {
                "align": false,
                "alignLevel": null
              }
            },
            {
              "aliasColors": {},
              "bars": false,
              "dashLength": 10,
              "dashes": false,
              "datasource": "Prometheus",
              "editable": true,
              "error": false,
              "fieldConfig": {
                "defaults": {
                  "custom": {}
                },
                "overrides": []
              },
              "fill": 0,
              "fillGradient": 0,
              "gridPos": {
                "h": 7,
                "w": 12,
                "x": 12,
                "y": 21
              },
              "hiddenSeries": false,
              "id": 41,
              "legend": {
                "avg": false,
                "current": false,
                "max": false,
                "min": false,
                "show": false,
                "total": false,
                "values": false
              },
              "lines": true,
              "linewidth": 2,
              "links": [],
              "nullPointMode": "connected",
              "options": {
                "dataLinks": []
              },
              "percentage": false,
              "pointradius": 5,
              "points": false,
              "renderer": "flot",
              "seriesOverrides": [],
              "spaceLength": 10,
              "stack": true,
              "steppedLine": false,
              "targets": [
                {
                  "expr": "sum(grpc_server_started_total{grpc_service=\"etcdserverpb.Watch\",grpc_type=\"bidi_stream\"}) - sum(grpc_server_handled_total{grpc_service=\"etcdserverpb.Watch\",grpc_type=\"bidi_stream\"})",
                  "format": "time_series",
                  "intervalFactor": 2,
                  "legendFormat": "Watch Streams",
                  "metric": "grpc_server_handled_total",
                  "refId": "A",
                  "step": 60
                },
                {
                  "expr": "sum(grpc_server_started_total{grpc_service=\"etcdserverpb.Lease\",grpc_type=\"bidi_stream\"}) - sum(grpc_server_handled_total{grpc_service=\"etcdserverpb.Lease\",grpc_type=\"bidi_stream\"})",
                  "format": "time_series",
                  "intervalFactor": 2,
                  "legendFormat": "Lease Streams",
                  "metric": "grpc_server_handled_total",
                  "refId": "B",
                  "step": 60
                }
              ],
              "thresholds": [],
              "timeFrom": null,
              "timeRegions": [],
              "timeShift": null,
              "title": "Active Streams",
              "tooltip": {
                "msResolution": false,
                "shared": true,
                "sort": 0,
                "value_type": "individual"
              },
              "type": "graph",
              "xaxis": {
                "buckets": null,
                "mode": "time",
                "name": null,
                "show": true,
                "values": []
              },
              "yaxes": [
                {
                  "format": "short",
                  "label": "",
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                },
                {
                  "format": "short",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                }
              ],
              "yaxis": {
                "align": false,
                "alignLevel": null
              }
            },
            {
              "aliasColors": {},
              "bars": false,
              "dashLength": 10,
              "dashes": false,
              "datasource": "Prometheus",
              "editable": true,
              "error": false,
              "fieldConfig": {
                "defaults": {
                  "custom": {}
                },
                "overrides": []
              },
              "fill": 5,
              "fillGradient": 0,
              "gridPos": {
                "h": 7,
                "w": 6,
                "x": 0,
                "y": 28
              },
              "hiddenSeries": false,
              "id": 22,
              "legend": {
                "avg": false,
                "current": false,
                "max": false,
                "min": false,
                "show": false,
                "total": false,
                "values": false
              },
              "lines": true,
              "linewidth": 2,
              "links": [],
              "nullPointMode": "connected",
              "options": {
                "dataLinks": []
              },
              "percentage": false,
              "pointradius": 5,
              "points": false,
              "renderer": "flot",
              "seriesOverrides": [],
              "spaceLength": 10,
              "stack": true,
              "steppedLine": false,
              "targets": [
                {
                  "expr": "rate(etcd_network_client_grpc_received_bytes_total[5m])",
                  "format": "time_series",
                  "intervalFactor": 2,
                  "legendFormat": "{{instance}} Client Traffic In",
                  "metric": "etcd_network_client_grpc_received_bytes_total",
                  "refId": "A",
                  "step": 120
                }
              ],
              "thresholds": [],
              "timeFrom": null,
              "timeRegions": [],
              "timeShift": null,
              "title": "Client Traffic In",
              "tooltip": {
                "msResolution": false,
                "shared": true,
                "sort": 0,
                "value_type": "individual"
              },
              "type": "graph",
              "xaxis": {
                "buckets": null,
                "mode": "time",
                "name": null,
                "show": true,
                "values": []
              },
              "yaxes": [
                {
                  "format": "short",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                },
                {
                  "format": "short",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                }
              ],
              "yaxis": {
                "align": false,
                "alignLevel": null
              }
            },
            {
              "aliasColors": {},
              "bars": false,
              "dashLength": 10,
              "dashes": false,
              "datasource": "Prometheus",
              "editable": true,
              "error": false,
              "fieldConfig": {
                "defaults": {
                  "custom": {}
                },
                "overrides": []
              },
              "fill": 5,
              "fillGradient": 0,
              "gridPos": {
                "h": 7,
                "w": 6,
                "x": 6,
                "y": 28
              },
              "hiddenSeries": false,
              "id": 21,
              "legend": {
                "avg": false,
                "current": false,
                "max": false,
                "min": false,
                "show": false,
                "total": false,
                "values": false
              },
              "lines": true,
              "linewidth": 2,
              "links": [],
              "nullPointMode": "connected",
              "options": {
                "dataLinks": []
              },
              "percentage": false,
              "pointradius": 5,
              "points": false,
              "renderer": "flot",
              "seriesOverrides": [],
              "spaceLength": 10,
              "stack": true,
              "steppedLine": false,
              "targets": [
                {
                  "expr": "rate(etcd_network_client_grpc_sent_bytes_total[5m])",
                  "format": "time_series",
                  "intervalFactor": 2,
                  "legendFormat": "{{instance}} Client Traffic Out",
                  "metric": "etcd_network_client_grpc_sent_bytes_total",
                  "refId": "A",
                  "step": 120
                }
              ],
              "thresholds": [],
              "timeFrom": null,
              "timeRegions": [],
              "timeShift": null,
              "title": "Client Traffic Out",
              "tooltip": {
                "msResolution": false,
                "shared": true,
                "sort": 0,
                "value_type": "individual"
              },
              "type": "graph",
              "xaxis": {
                "buckets": null,
                "mode": "time",
                "name": null,
                "show": true,
                "values": []
              },
              "yaxes": [
                {
                  "format": "Bps",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                },
                {
                  "format": "short",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                }
              ],
              "yaxis": {
                "align": false,
                "alignLevel": null
              }
            },
            {
              "aliasColors": {},
              "bars": false,
              "dashLength": 10,
              "dashes": false,
              "datasource": "Prometheus",
              "decimals": 0,
              "editable": true,
              "error": false,
              "fieldConfig": {
                "defaults": {
                  "custom": {}
                },
                "overrides": []
              },
              "fill": 0,
              "fillGradient": 0,
              "gridPos": {
                "h": 7,
                "w": 12,
                "x": 12,
                "y": 28
              },
              "hiddenSeries": false,
              "id": 19,
              "legend": {
                "alignAsTable": false,
                "avg": false,
                "current": false,
                "max": false,
                "min": false,
                "rightSide": false,
                "show": false,
                "total": false,
                "values": false
              },
              "lines": true,
              "linewidth": 2,
              "links": [],
              "nullPointMode": "connected",
              "options": {
                "dataLinks": []
              },
              "percentage": false,
              "pointradius": 5,
              "points": false,
              "renderer": "flot",
              "seriesOverrides": [],
              "spaceLength": 10,
              "stack": false,
              "steppedLine": false,
              "targets": [
                {
                  "expr": "changes(etcd_server_leader_changes_seen_total[1d])",
                  "format": "time_series",
                  "intervalFactor": 2,
                  "legendFormat": "{{instance}} Total Leader Elections Per Day",
                  "metric": "etcd_server_leader_changes_seen_total",
                  "refId": "A",
                  "step": 60
                }
              ],
              "thresholds": [],
              "timeFrom": null,
              "timeRegions": [],
              "timeShift": null,
              "title": "Total Leader Elections Per Day",
              "tooltip": {
                "msResolution": false,
                "shared": true,
                "sort": 0,
                "value_type": "individual"
              },
              "type": "graph",
              "xaxis": {
                "buckets": null,
                "mode": "time",
                "name": null,
                "show": true,
                "values": []
              },
              "yaxes": [
                {
                  "format": "short",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                },
                {
                  "format": "short",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                }
              ],
              "yaxis": {
                "align": false,
                "alignLevel": null
              }
            },
            {
              "aliasColors": {},
              "bars": false,
              "dashLength": 10,
              "dashes": false,
              "datasource": "Prometheus",
              "editable": true,
              "error": false,
              "fieldConfig": {
                "defaults": {
                  "custom": {}
                },
                "overrides": []
              },
              "fill": 0,
              "fillGradient": 0,
              "gridPos": {
                "h": 7,
                "w": 12,
                "x": 0,
                "y": 35
              },
              "hiddenSeries": false,
              "id": 40,
              "legend": {
                "avg": false,
                "current": false,
                "max": false,
                "min": false,
                "show": false,
                "total": false,
                "values": false
              },
              "lines": true,
              "linewidth": 2,
              "links": [],
              "nullPointMode": "connected",
              "options": {
                "dataLinks": []
              },
              "percentage": false,
              "pointradius": 5,
              "points": false,
              "renderer": "flot",
              "seriesOverrides": [],
              "spaceLength": 10,
              "stack": false,
              "steppedLine": false,
              "targets": [
                {
                  "expr": "sum(rate(etcd_server_proposals_failed_total[5m]))",
                  "format": "time_series",
                  "intervalFactor": 2,
                  "legendFormat": "Proposal Failure Rate",
                  "metric": "etcd_server_proposals_failed_total",
                  "refId": "A",
                  "step": 60
                },
                {
                  "expr": "sum(etcd_server_proposals_pending)",
                  "format": "time_series",
                  "intervalFactor": 2,
                  "legendFormat": "Proposal Pending Total",
                  "metric": "etcd_server_proposals_pending",
                  "refId": "B",
                  "step": 60
                },
                {
                  "expr": "sum(rate(etcd_server_proposals_committed_total[5m]))",
                  "format": "time_series",
                  "intervalFactor": 2,
                  "legendFormat": "Proposal Commit Rate",
                  "metric": "etcd_server_proposals_committed_total",
                  "refId": "C",
                  "step": 60
                },
                {
                  "expr": "sum(rate(etcd_server_proposals_applied_total[5m]))",
                  "format": "time_series",
                  "intervalFactor": 2,
                  "legendFormat": "Proposal Apply Rate",
                  "refId": "D",
                  "step": 60
                }
              ],
              "thresholds": [],
              "timeFrom": null,
              "timeRegions": [],
              "timeShift": null,
              "title": "Raft Proposals",
              "tooltip": {
                "msResolution": false,
                "shared": true,
                "sort": 0,
                "value_type": "individual"
              },
              "type": "graph",
              "xaxis": {
                "buckets": null,
                "mode": "time",
                "name": null,
                "show": true,
                "values": []
              },
              "yaxes": [
                {
                  "format": "short",
                  "label": "",
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                },
                {
                  "format": "short",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                }
              ],
              "yaxis": {
                "align": false,
                "alignLevel": null
              }
            },
            {
              "aliasColors": {},
              "bars": false,
              "dashLength": 10,
              "dashes": false,
              "datasource": "Prometheus",
              "description": "indicates how many proposals are queued to commit. Rising pending proposals suggests there is a high client load or the member cannot commit proposals.",
              "fieldConfig": {
                "defaults": {
                  "custom": {}
                },
                "overrides": []
              },
              "fill": 1,
              "fillGradient": 0,
              "gridPos": {
                "h": 7,
                "w": 12,
                "x": 12,
                "y": 35
              },
              "hiddenSeries": false,
              "id": 5,
              "legend": {
                "avg": false,
                "current": false,
                "max": false,
                "min": false,
                "show": true,
                "total": false,
                "values": false
              },
              "lines": true,
              "linewidth": 1,
              "links": [],
              "nullPointMode": "null",
              "options": {
                "dataLinks": []
              },
              "percentage": false,
              "pointradius": 5,
              "points": false,
              "renderer": "flot",
              "seriesOverrides": [],
              "spaceLength": 10,
              "stack": false,
              "steppedLine": false,
              "targets": [
                {
                  "expr": "sum(etcd_server_proposals_pending)",
                  "format": "time_series",
                  "intervalFactor": 2,
                  "legendFormat": "Proposals pending",
                  "refId": "A",
                  "step": 60
                }
              ],
              "thresholds": [],
              "timeFrom": null,
              "timeRegions": [],
              "timeShift": null,
              "title": "Proposals pending",
              "tooltip": {
                "shared": true,
                "sort": 0,
                "value_type": "individual"
              },
              "type": "graph",
              "xaxis": {
                "buckets": null,
                "mode": "time",
                "name": null,
                "show": true,
                "values": []
              },
              "yaxes": [
                {
                  "format": "short",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                },
                {
                  "format": "short",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                }
              ],
              "yaxis": {
                "align": false,
                "alignLevel": null
              }
            },
            {
              "aliasColors": {},
              "bars": false,
              "dashLength": 10,
              "dashes": false,
              "datasource": "Prometheus",
              "description": "proposals_committed_total records the total number of consensus proposals committed. This gauge should increase over time if the cluster is healthy. Several healthy members of an etcd cluster may have different total committed proposals at once. This discrepancy may be due to recovering from peers after starting, lagging behind the leader, or being the leader and therefore having the most commits. It is important to monitor this metric across all the members in the cluster; a consistently large lag between a single member and its leader indicates that member is slow or unhealthy.\n\nproposals_applied_total records the total number of consensus proposals applied. The etcd server applies every committed proposal asynchronously. The difference between proposals_committed_total and proposals_applied_total should usually be small (within a few thousands even under high load). If the difference between them continues to rise, it indicates that the etcd server is overloaded. This might happen when applying expensive queries like heavy range queries or large txn operations.",
              "fieldConfig": {
                "defaults": {
                  "custom": {}
                },
                "overrides": []
              },
              "fill": 1,
              "fillGradient": 0,
              "gridPos": {
                "h": 7,
                "w": 12,
                "x": 0,
                "y": 42
              },
              "hiddenSeries": false,
              "id": 2,
              "legend": {
                "alignAsTable": true,
                "avg": true,
                "current": true,
                "max": true,
                "min": false,
                "rightSide": false,
                "show": true,
                "total": false,
                "values": true
              },
              "lines": true,
              "linewidth": 1,
              "links": [],
              "nullPointMode": "null",
              "options": {
                "dataLinks": []
              },
              "percentage": false,
              "pointradius": 5,
              "points": false,
              "renderer": "flot",
              "seriesOverrides": [],
              "spaceLength": 10,
              "stack": false,
              "steppedLine": false,
              "targets": [
                {
                  "expr": "sum(rate(etcd_server_proposals_committed_total[5m]))",
                  "format": "time_series",
                  "intervalFactor": 2,
                  "legendFormat": "total number of consensus proposals committed",
                  "metric": "",
                  "refId": "A",
                  "step": 60
                },
                {
                  "expr": "sum(rate(etcd_server_proposals_applied_total[5m]))",
                  "format": "time_series",
                  "intervalFactor": 2,
                  "legendFormat": "total number of consensus proposals applied",
                  "metric": "",
                  "refId": "B",
                  "step": 60
                }
              ],
              "thresholds": [],
              "timeFrom": null,
              "timeRegions": [],
              "timeShift": null,
              "title": "The total number of consensus proposals committed",
              "tooltip": {
                "shared": true,
                "sort": 0,
                "value_type": "individual"
              },
              "type": "graph",
              "xaxis": {
                "buckets": null,
                "mode": "time",
                "name": null,
                "show": true,
                "values": []
              },
              "yaxes": [
                {
                  "format": "short",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                },
                {
                  "format": "short",
                  "label": "",
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                }
              ],
              "yaxis": {
                "align": false,
                "alignLevel": null
              }
            },
            {
              "aliasColors": {},
              "bars": true,
              "dashLength": 10,
              "dashes": false,
              "datasource": "Prometheus",
              "editable": true,
              "error": false,
              "fieldConfig": {
                "defaults": {
                  "custom": {}
                },
                "overrides": []
              },
              "fill": 0,
              "fillGradient": 0,
              "gridPos": {
                "h": 7,
                "w": 12,
                "x": 12,
                "y": 42
              },
              "hiddenSeries": false,
              "id": 46,
              "legend": {
                "avg": false,
                "current": false,
                "max": false,
                "min": false,
                "show": true,
                "total": false,
                "values": false
              },
              "lines": false,
              "linewidth": 2,
              "links": [],
              "nullPointMode": "connected",
              "options": {
                "dataLinks": []
              },
              "percentage": false,
              "pointradius": 5,
              "points": false,
              "renderer": "flot",
              "seriesOverrides": [],
              "spaceLength": 10,
              "stack": true,
              "steppedLine": false,
              "targets": [
                {
                  "expr": "sum by (kubernetes_pod_name) (rate(etcd_network_peer_sent_failures_total[5m]))",
                  "format": "time_series",
                  "interval": "",
                  "intervalFactor": 2,
                  "legendFormat": "{{ kubernetes_pod_name }}",
                  "metric": "grpc_server_started_total",
                  "refId": "A",
                  "step": 60
                }
              ],
              "thresholds": [],
              "timeFrom": null,
              "timeRegions": [],
              "timeShift": null,
              "title": "Send to peer failures",
              "tooltip": {
                "msResolution": false,
                "shared": true,
                "sort": 0,
                "value_type": "individual"
              },
              "type": "graph",
              "xaxis": {
                "buckets": null,
                "mode": "time",
                "name": null,
                "show": true,
                "values": []
              },
              "yaxes": [
                {
                  "format": "short",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                },
                {
                  "format": "short",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                }
              ],
              "yaxis": {
                "align": false,
                "alignLevel": null
              }
            },
            {
              "aliasColors": {},
              "bars": false,
              "dashLength": 10,
              "dashes": false,
              "datasource": "Prometheus",
              "editable": true,
              "error": false,
              "fieldConfig": {
                "defaults": {
                  "custom": {}
                },
                "overrides": []
              },
              "fill": 0,
              "fillGradient": 0,
              "gridPos": {
                "h": 7,
                "w": 12,
                "x": 0,
                "y": 49
              },
              "hiddenSeries": false,
              "id": 45,
              "legend": {
                "avg": false,
                "current": false,
                "max": false,
                "min": false,
                "show": false,
                "total": false,
                "values": false
              },
              "lines": true,
              "linewidth": 2,
              "links": [],
              "nullPointMode": "connected",
              "options": {
                "dataLinks": []
              },
              "percentage": false,
              "pointradius": 5,
              "points": false,
              "renderer": "flot",
              "seriesOverrides": [],
              "spaceLength": 10,
              "stack": false,
              "steppedLine": false,
              "targets": [
                {
                  "expr": "histogram_quantile(0.99, sum(rate(etcd_network_peer_round_trip_time_seconds_bucket[5m])) by (le))",
                  "format": "time_series",
                  "interval": "",
                  "intervalFactor": 2,
                  "legendFormat": "p99",
                  "metric": "grpc_server_started_total",
                  "refId": "A",
                  "step": 60
                },
                {
                  "expr": "histogram_quantile(0.95, sum(rate(etcd_network_peer_round_trip_time_seconds_bucket[5m])) by (le))",
                  "format": "time_series",
                  "interval": "",
                  "intervalFactor": 2,
                  "legendFormat": "p95",
                  "metric": "grpc_server_started_total",
                  "refId": "B",
                  "step": 60
                },
                {
                  "expr": "histogram_quantile(0.50, sum(rate(etcd_network_peer_round_trip_time_seconds_bucket[5m])) by (le))",
                  "format": "time_series",
                  "interval": "",
                  "intervalFactor": 2,
                  "legendFormat": "p50",
                  "metric": "grpc_server_started_total",
                  "refId": "C",
                  "step": 60
                },
                {
                  "expr": "histogram_quantile(0, sum(rate(etcd_network_peer_round_trip_time_seconds_bucket[5m])) by (le))",
                  "format": "time_series",
                  "interval": "",
                  "intervalFactor": 2,
                  "legendFormat": "p0",
                  "metric": "grpc_server_started_total",
                  "refId": "D",
                  "step": 60
                }
              ],
              "thresholds": [],
              "timeFrom": null,
              "timeRegions": [],
              "timeShift": null,
              "title": "Peer Latency",
              "tooltip": {
                "msResolution": false,
                "shared": true,
                "sort": 0,
                "value_type": "individual"
              },
              "type": "graph",
              "xaxis": {
                "buckets": null,
                "mode": "time",
                "name": null,
                "show": true,
                "values": []
              },
              "yaxes": [
                {
                  "format": "s",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                },
                {
                  "format": "short",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                }
              ],
              "yaxis": {
                "align": false,
                "alignLevel": null
              }
            },
            {
              "aliasColors": {},
              "bars": false,
              "dashLength": 10,
              "dashes": false,
              "datasource": "Prometheus",
              "fieldConfig": {
                "defaults": {
                  "custom": {}
                },
                "overrides": []
              },
              "fill": 1,
              "fillGradient": 0,
              "gridPos": {
                "h": 7,
                "w": 24,
                "x": 0,
                "y": 56
              },
              "hiddenSeries": false,
              "id": 7,
              "legend": {
                "avg": false,
                "current": false,
                "max": false,
                "min": false,
                "show": true,
                "total": false,
                "values": false
              },
              "lines": true,
              "linewidth": 1,
              "links": [],
              "nullPointMode": "null",
              "options": {
                "dataLinks": []
              },
              "percentage": false,
              "pointradius": 5,
              "points": false,
              "renderer": "flot",
              "seriesOverrides": [],
              "spaceLength": 10,
              "stack": false,
              "steppedLine": false,
              "targets": [
                {
                  "expr": "sum(rate(etcd_disk_wal_fsync_duration_seconds_sum[1m]))",
                  "format": "time_series",
                  "intervalFactor": 2,
                  "legendFormat": "\tThe latency distributions of fsync called by wal",
                  "refId": "A",
                  "step": 30
                },
                {
                  "expr": "sum(rate(etcd_disk_backend_commit_duration_seconds_sum[1m]))",
                  "format": "time_series",
                  "intervalFactor": 2,
                  "legendFormat": "The latency distributions of commit called by backend",
                  "refId": "B",
                  "step": 30
                }
              ],
              "thresholds": [],
              "timeFrom": null,
              "timeRegions": [],
              "timeShift": null,
              "title": "Disks operations",
              "tooltip": {
                "shared": true,
                "sort": 0,
                "value_type": "individual"
              },
              "type": "graph",
              "xaxis": {
                "buckets": null,
                "mode": "time",
                "name": null,
                "show": true,
                "values": []
              },
              "yaxes": [
                {
                  "format": "short",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                },
                {
                  "format": "short",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                }
              ],
              "yaxis": {
                "align": false,
                "alignLevel": null
              }
            },
            {
              "aliasColors": {},
              "bars": false,
              "dashLength": 10,
              "dashes": false,
              "datasource": "Prometheus",
              "fieldConfig": {
                "defaults": {
                  "custom": {}
                },
                "overrides": []
              },
              "fill": 1,
              "fillGradient": 0,
              "gridPos": {
                "h": 7,
                "w": 24,
                "x": 0,
                "y": 63
              },
              "hiddenSeries": false,
              "id": 8,
              "legend": {
                "avg": false,
                "current": false,
                "max": false,
                "min": false,
                "show": true,
                "total": false,
                "values": false
              },
              "lines": true,
              "linewidth": 1,
              "links": [],
              "nullPointMode": "null",
              "options": {
                "dataLinks": []
              },
              "percentage": false,
              "pointradius": 5,
              "points": false,
              "renderer": "flot",
              "seriesOverrides": [],
              "spaceLength": 10,
              "stack": false,
              "steppedLine": false,
              "targets": [
                {
                  "expr": "sum(rate(etcd_network_client_grpc_received_bytes_total[1m]))",
                  "format": "time_series",
                  "intervalFactor": 2,
                  "legendFormat": "The total number of bytes received by grpc clients",
                  "refId": "A",
                  "step": 30
                },
                {
                  "expr": "sum(rate(etcd_network_client_grpc_sent_bytes_total[1m]))",
                  "format": "time_series",
                  "intervalFactor": 2,
                  "legendFormat": "The total number of bytes sent to grpc clients",
                  "refId": "B",
                  "step": 30
                }
              ],
              "thresholds": [],
              "timeFrom": null,
              "timeRegions": [],
              "timeShift": null,
              "title": "Network",
              "tooltip": {
                "shared": true,
                "sort": 0,
                "value_type": "individual"
              },
              "type": "graph",
              "xaxis": {
                "buckets": null,
                "mode": "time",
                "name": null,
                "show": true,
                "values": []
              },
              "yaxes": [
                {
                  "format": "short",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                },
                {
                  "format": "short",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                }
              ],
              "yaxis": {
                "align": false,
                "alignLevel": null
              }
            },
            {
              "aliasColors": {},
              "bars": false,
              "dashLength": 10,
              "dashes": false,
              "datasource": "Prometheus",
              "description": "Abnormally high snapshot duration (snapshot_save_total_duration_seconds) indicates disk issues and might cause the cluster to be unstable.",
              "fieldConfig": {
                "defaults": {
                  "custom": {}
                },
                "overrides": []
              },
              "fill": 1,
              "fillGradient": 0,
              "gridPos": {
                "h": 7,
                "w": 24,
                "x": 0,
                "y": 70
              },
              "hiddenSeries": false,
              "id": 9,
              "legend": {
                "avg": false,
                "current": false,
                "max": false,
                "min": false,
                "show": true,
                "total": false,
                "values": false
              },
              "lines": true,
              "linewidth": 1,
              "links": [],
              "nullPointMode": "null",
              "options": {
                "dataLinks": []
              },
              "percentage": false,
              "pointradius": 5,
              "points": false,
              "renderer": "flot",
              "seriesOverrides": [],
              "spaceLength": 10,
              "stack": false,
              "steppedLine": false,
              "targets": [
                {
                  "expr": "sum(rate(etcd_debugging_snap_save_total_duration_seconds_sum[1m]))",
                  "format": "time_series",
                  "intervalFactor": 2,
                  "legendFormat": "The total latency distributions of save called by snapshot",
                  "refId": "A",
                  "step": 30
                }
              ],
              "thresholds": [],
              "timeFrom": null,
              "timeRegions": [],
              "timeShift": null,
              "title": "Snapshot duration",
              "tooltip": {
                "shared": true,
                "sort": 0,
                "value_type": "individual"
              },
              "type": "graph",
              "xaxis": {
                "buckets": null,
                "mode": "time",
                "name": null,
                "show": true,
                "values": []
              },
              "yaxes": [
                {
                  "format": "short",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                },
                {
                  "format": "short",
                  "label": null,
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                }
              ],
              "yaxis": {
                "align": false,
                "alignLevel": null
              }
            }
          ],
          "refresh": "5s",
          "schemaVersion": 25,
          "style": "dark",
          "tags": [],
          "templating": {
            "list": []
          },
          "time": {
            "from": "now-1h",
            "to": "now"
          },
          "timepicker": {
            "refresh_intervals": [
              "10s",
              "30s",
              "1m",
              "5m",
              "15m",
              "30m",
              "1h",
              "2h",
              "1d"
            ],
            "time_options": [
              "5m",
              "15m",
              "1h",
              "6h",
              "12h",
              "24h",
              "2d",
              "7d",
              "30d"
            ]
          },
          "timezone": "browser",
          "title": "Etcd by Prometheus",
          "uid": "bF6YH8VGz",
          "version": 1
        }
sidecar:
  dashboards:
    enabled: true
dashboardProviders:
  dashboardproviders.yaml:
    apiVersion: 1
    providers:
    - name: 'default'
      orgId: 1
      folder: ''
      type: file
      disableDeletion: false
      editable: true
      options:
        path: /var/lib/grafana/dashboards/default
EOF
  ]

}
