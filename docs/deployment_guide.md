# Deployment Guide for Azure Snapshot Cleanup Tool

This guide covers various deployment scenarios for the Azure Snapshot Cleanup Tool, focusing on automation and scheduled execution.

## Table of Contents

1. [Running as a Scheduled Task](#running-as-a-scheduled-task)
2. [Running in Azure](#running-in-azure)
3. [Using Service Principals](#using-service-principals)
4. [Sample Deployment Scenarios](#sample-deployment-scenarios)

## Running as a Scheduled Task

### Linux (Cron Job)

1. Create a shell script to execute the cleanup tool:

```bash
#!/bin/bash
cd /path/to/azure-snapshot-cleanup
source venv/bin/activate
python scripts/azure_snapshot_cleanup.py --auth-method service-principal --sp-client-id CLIENT_ID --sp-client-secret CLIENT_SECRET --sp-tenant-id TENANT_ID --export /var/log/azure-snapshot-cleanup/$(date +%Y%m%d).json
```

2. Make the script executable:
```
chmod +x /path/to/run_cleanup.sh
```

3. Add a cron job to run weekly:
```
0 0 * * 0 /path/to/run_cleanup.sh
```

### Windows (Task Scheduler)

1. Create a batch script:
```batch
@echo off
cd /path/to/azure-snapshot-cleanup
call venv\Scripts\activate.bat
python scripts\azure_snapshot_cleanup.py --auth-method service-principal --sp-client-id CLIENT_ID --sp-client-secret CLIENT_SECRET --sp-tenant-id TENANT_ID --export C:\Logs\azure-snapshot-cleanup\%date:~10,4%%date:~4,2%%date:~7,2%.json
```

2. Create a scheduled task:
```
schtasks /create /tn "Azure Snapshot Cleanup" /tr C:\path\to\run_cleanup.bat /sc weekly /d SUN /st 00:00
```

## Running in Azure

### Azure Automation Runbook

1. Create a Python Runbook in Azure Automation.

2. Install the required Python packages in the Automation account.

3. Copy the content of `azure_snapshot_cleanup.py` to the Runbook.

4. Configure a schedule for the Runbook execution.

5. Use Managed Identity authentication by modifying the script parameters:
```
--auth-method managed-identity
```

### Azure Functions

1. Create an Azure Function App with a timer trigger.

2. Include the Python script and requirements.

3. Set up Managed Identity for the Function App.

4. Configure the function to run on your desired schedule.

## Using Service Principals

For automated scenarios, it's recommended to use Service Principals with limited permissions:

1. Create a Service Principal:
```
az ad sp create-for-rbac --name "AzureSnapshotCleanup" --role "Reader" --scopes /subscriptions/SUBSCRIPTION_ID
```

2. Grant additional permissions for snapshot deletion:
```
az role assignment create --assignee PRINCIPAL_ID --role "Storage Account Contributor" --scope /subscriptions/SUBSCRIPTION_ID
```

3. Use the Service Principal credentials in the script:
```
--auth-method service-principal --sp-client-id CLIENT_ID --sp-client-secret CLIENT_SECRET --sp-tenant-id TENANT_ID
```

## Sample Deployment Scenarios

### Daily Reports, Weekly Cleanup

1. Setup two scheduled tasks:
   - Daily task for reporting only
   - Weekly task for cleanup with deletion

### Multi-Subscription Enterprise

1. Create multiple Service Principals with appropriate permissions
2. Set up separate scheduled tasks for different subscription groups
3. Configure centralized logging and notification

### Audit-Only Mode

For environments with strict change control:

1. Run in report-only mode
2. Export results to JSON
3. Send reports to appropriate teams
4. Manual approval for cleanup actions