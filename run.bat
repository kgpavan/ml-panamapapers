REM cmd /c ml bootstrap local

REM cmd /c ml clean content local

echo "Deploying Modules"
cmd /c ml deploy modules local
ECHO Addresses
cmd /c mlcp import -host localhost -port 8041 -username admin -password admin  -input_file_path ./data/Addresses.csv -input_file_type delimited_text -document_type json -delimiter , -uri_id node_id -output_uri_suffix ".json" -output_uri_prefix /addresses/ -output_collections Address -thread_count 8 -transform_module /main/transform/node-transform.xqy -transform_namespace "http://marklogic.com/pp/transform/node-transform" -transform_param "node"
ECHO Entities
cmd  /c mlcp import -host localhost -port 8041 -username admin -password admin  -input_file_path ./data/Entities.csv -input_file_type delimited_text -document_type json -delimiter , -uri_id node_id -output_uri_suffix ".json" -output_uri_prefix /entities/ -output_collections Entity -thread_count 8 -transform_module /main/transform/node-transform.xqy -transform_namespace "http://marklogic.com/pp/transform/node-transform" -transform_param "node"
ECHO Intermediaries
cmd  /c mlcp import -host localhost -port 8041 -username admin -password admin  -input_file_path ./data/Intermediaries.csv -input_file_type delimited_text -document_type json -delimiter , -uri_id node_id -output_uri_suffix ".json" -output_uri_prefix /intermediaries/ -output_collections Intermediary -thread_count 8 -transform_module /main/transform/node-transform.xqy -transform_namespace "http://marklogic.com/pp/transform/node-transform" -transform_param "node"
ECHO Officers
cmd  /c  mlcp import -host localhost -port 8041 -username admin -password admin  -input_file_path ./data/Officers.csv -input_file_type delimited_text -document_type json -delimiter , -uri_id node_id -output_uri_suffix ".json" -output_uri_prefix /officers/ -output_collections Officer -thread_count 8 -transform_module /main/transform/node-transform.xqy -transform_namespace "http://marklogic.com/pp/transform/node-transform" -transform_param "node"
ECHO all_edges
cmd  /c mlcp import -host localhost -port 8041 -username admin -password admin  -input_file_path ./data/all_edges.csv -input_file_type delimited_text -document_type json -delimiter ,  -output_uri_suffix ".json" -output_uri_prefix /edges/ -output_collections edges -thread_count 8 -transform_module /main/transform/edge-transform.xqy -transform_namespace "http://marklogic.com/pp/transform/edge-transform"

