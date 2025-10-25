import json,os,sys
import toolsVariables,applyConfig

os.system(f"echo '' > '{toolsVariables.casstanjeShellDir}/user-config.json'")

applyConfig.main()