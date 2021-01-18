naavizl - A Network Analysis And Visualization System
====================
Summary
--------------

Naavizl is a system for collection, analysis, and visualization of network data.

Architecture
--------------
![Basic Architecture](naavizlarch.png)

The system consists of naavizlclient images that run on the collecting network device, one or more naazvizlservers that export the network data to a Clickhouse database, and Grafana visualization system.

Components
------------

naavizlclient
--------------
The naavizlclient is a Docker based container image that collects information about the network. The current collection mechanism is yaf (https://tools.netsa.cert.org/yaf/index.html) which is part of the CERT NetSA Security Suite.

naavizlserver
-------------
The naavizlserver is a Docker based container image that listens for network information from collector clients. The current collector clients that are supported are the naavizlclient and any netflow-v9 collector. This component processes the network information and exports it to the clickhouse component

clickhouse
------------
The clickhouse component is a Docker based container running the ClickHouse datastore (https://clickhouse.tech/).

grafana
------------
The grafana component is any Grafana based instance (https://github.com/grafana/grafana). It communicates with the clickhouse component using the ClickHouse Grafana Datasource Plugin (https://grafana.com/grafana/plugins/vertamedia-clickhouse-datasource)

There is a sample grafana dashboard (grafana_clickhouse_dashboard.json) that can be imported and used for viewing the information.
Sample Output
---------------
![Grafana Screenshot](grafanaexample.png)

Installing the System
---------------------
To install the system, first install and configure the Clickhouse database instance. The clickhouse directory contains a README.md file that describes the stepe to perform a sample small installation on Kubernetes.

Next, install the naavizlserver container. This runs on the server and listens for Netflow v9 and naavizlclient/yaf network data. The naavizlserver directory contains a README.md which describes how to deploy the container.

Finally, install and configure Grafana and the ClickHouse Grafana Datasource Plugin to view the collected data.