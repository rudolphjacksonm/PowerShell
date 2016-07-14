Syncs Office365 distribution groups with Active Directory security groups.
In this particular case, security groups are created based on the Title field in AD. 
The title field (and corresponding security group) are then paired to a distribution group in
Office365.

This script is designed to be ran on a daily schedule, as frequently as every 5 minutes if you like.
