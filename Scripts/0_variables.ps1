$rand=42
#
$rg = "<<your resource group>>"
$loc = "<<your location>>"
$sub = "<<your subscription id>>"
$tenant_id = "<<your Azure tenant id>>"
$Environment = "AzureCloud"
#
$fun_name = "test-synfunsec" + $rand + "-fun"
$fun_stor = "testsynfunsecstor" + $rand
$fun_app_plan = "test-synfunsec" + $rand + "-funplan"
$HTTPTrigger_name = "HttpTriggerRunPythonScript"
#
$synapse_stor = "testsynfunsecstor" + $rand + "syn"
$synapse_name = "test-synfunsec" + $rand + "-syn"