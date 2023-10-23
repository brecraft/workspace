import os
import tableauserverclient as TSC
from minio import Minio
import tempfile

# Tableau Server/Online information
tableau_auth = TSC.TableauAuth('', '', '')  # Replace with your credentials
server = TSC.Server('', use_server_version=True)  # Replace with your Tableau Cloud URL
tableau_datasource = 'yourtableaudatasource'

# MinIO Server information
minio_client = Minio('',
                     access_key='',
                     secret_key='',
                     secure=False)  # Set secure=True for HTTPS

# MinIO Bucket and File details
minio_bucket = 'yourbucket'
minio_file = 'yourfile.parquet'

# Create a temporary directory to save the downloaded data source file
temp_dir = tempfile.mkdtemp()

# Download the file from MinIO
try:
    minio_client.fget_object(minio_bucket, minio_file, os.path.join(temp_dir, minio_file))
    print(f"File '{minio_file}' downloaded successfully from MinIO to '{temp_dir}'")
except Exception as e:
    print(f"Error downloading file from MinIO: {str(e)}")

# Create a connection to Tableau Server/Online
with server.auth.sign_in(tableau_auth):

    # Get the project Id
    found = [proj for proj in TSC.Pager(server.projects) if proj.name == tableau_datasource]

    # Define the data source details
    datasource = TSC.DatasourceItem(found[0].id, name='minIO_data')

    # Specify the path to the downloaded data source file
    local_datasource_file = os.path.join(temp_dir, minio_file)

    # Define publish mode - Overwrite, Append, or CreateNew
    publish_mode = TSC.Server.PublishMode.Overwrite

    # Publish the data source to Tableau Cloud
    datasource_item = server.datasources.publish(datasource,
                                                 local_datasource_file,
                                                 publish_mode,
                                                 as_job=True)

    # Wait for the publishing job to complete
    server.jobs.wait_for_job(datasource_item.id)

    # Check the status of the publishing job
    if datasource_item.finish_code == 1:
        print(f"Data source '{datasource.name}' published successfully to Tableau Cloud!")
    else:
        print(f"Data source publishing failed")
