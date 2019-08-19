
# Initialize 
create_scratch_org=""
deploy_toexisting_org=""
Org_user_alias=""
devhub="vscodeOrg"

# Quick select menu 
echo "**************"
PS3='Please make a selection: ' 
options=(
	"Create a scratch org"
	"Deploy to existing org" 
	"Quit")
	
select opt in "${options[@]}"
do 
	case $opt in 
	"Create a scratch org" )
		
		create_scratch_org="y" 
		break 
		;;
    "Deploy to existing org" )
		
		deploy_toexisting_org="y" 
		break
		;;
	"Quit" )
		exit 1
		break 
	;;
	*)
	;;
	esac
done	

#Create Scratch Org 
if [ $create_scratch_org ]; then 
	while [ ! -n "$Org_user_alias"  ]
	do
		echo "Please enter your org alias:"
		read Org_user_alias
	done
	
	rm -rf test || exist 1
	git clone -b master -- "https://github.com/kpapasani/brillio.git" test/sfdxdemo/ || exit 1
	cd  test/sfdxdemo/ || exit
	
	echo "Creating scratch org with alias $Org_user_alias"
	
	if sfdx force:org:create -f config/project-scratch-def.json -s -v $devhub  -a $Org_user_alias
	
	then 
		echo "Scratch org with alias $Org_user_alias created" 
		
		sfdx force:source:deploy -u $Org_user_alias	-x test/sfdxdemo/manifest/package.xml
		
		echo "Deploying to scratch org" 
	else 
		echo -e "$ERROR_MARKER Problem creating scratch org with alias $Org_user_alias" 
		exit 1
	fi 
else 
	echo "Not creating scratch org" 
fi 	
	
# Deploy to existing org 
if [ $deploy_toexisting_org ] ; then 
	while [ ! -n "$Org_user_alias"  ]
	do
		echo "Please enter your org alias:"
		read Org_user_alias
	done
	rm -rf test || exist 1
	git clone -b master -- "https://github.com/kpapasani/brillio.git" test/sfdxdemo/ || exit 1
	cd  test/sfdxdemo/ || exit
	
	echo "Deploying to existing org with alias $Org_user_alias" 
	
	if sfdx force:source:deploy -u $Org_user_alias	-m "ApexClass"
	then 
		echo "Deployed to $Org_user_alias" 
	else 
		echo -e "$ERROR_MARKER Problem deploying to username $Org_user_alias" 
		exit 1
	fi
else 
	echo "Not deploying to org" 
fi 

	




