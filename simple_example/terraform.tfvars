#--TenantInformation
tenancy_ocid="ocid1.tenancy.oc1..aaaaaaaaawdlyle7nxhakb43vw7m7kd6okg2x3oafgorze6bpigqqrdckq2a"
user_ocid="ocid1.user.oc1..aaaaaaaa7m74kvn5g6ydvg4hiesudgymfq72pgmjghavl6y5dvbfmunhs3ya"
fingerprint="c8:0a:fe:10:12:fb:5a:46:84:3a:c5:5a:27:30:50:09"
private_key_path="/home/opc/.oci/oci_api_key.pem"
compartment_ocid="ocid1.compartment.oc1..aaaaaaaal4zp4r4ywdqa7r7rrr37dgx2eg3f4sivutkqfjlp3evxskpg3jpq"
region="us-ashburn-1"

#----availabilitydomain(1,2or3)
AD="3"

#----AuthorizedpublicIPsingress(0.0.0.0/0meansallInternet)
authorized_ips="0.0.0.0/0"  #allInternet

#--variablesforBM/VMcreation
dbserver_hostname="CV-ORCL-test"
BootStrapFile_dbserver="userdata/db_server_bootstrap"
ssh_public_key_file_ol7="/home/opc/.ssh/id_rsa.pub"
os-version="7.5"
