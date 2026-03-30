# GoAnywhere Mini Projects:

These projects are meant to demonstrate the use of a GoAnywhere, this documentation showing the progress.


Use Case:

* Install GoAnywhere MFT  
* Steps
* Installing it is straight forward download from customer portal and can request an evaluation license
	* Installing it is straight forward download from customer portal and can request an evaluation license
	* other settings to configure 
	* edit session timeout: users >> admin security settings >> session timeout


## automation and orchestration example
* Create a PGP key via keyvault
* Once key is created you can create a project and via the project automate a process to upload a file / encrypt a file / decrypt a file.


## externalize the database

* externalizing the database allows the database to be controlled externally via mySQL.
* the pre-reqs for this is into install mySQL and setup a database and a user and allocate permissions to account.
* Go to System >> Database configuration
* Click switch database
* Select mySQL
* There are 3 prerequisites
* Create the new database
* Create a new user
* Provide all privileges to new user.

* Open MySQL.
* Be logged in as root or user that can grant permissions and create DB.\
* Enter the following commands
* This creates the database
```sql
CREATE DATABASE gadata CHARACTER SET utf8mb4
```

* This validates the database being created
```sql
SHOW DATABASES;

```

* This creats the user
'%' allows connection from any host
```sql
CREATE USER 'gadata'@'%' IDENTIFIED BY 'password';

```

* Consolidated snippet
```sql
CREATE USER 'gadata'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON gadata.* TO 'gadata'@'%';
FLUSH PRIVILEGES;

SHOW DATABASES;
SHOW GRANTS FOR 'gadata'@'%';
```

* Provide info for target database
	* Host
	* port
	* Database name
	* User

* Then follow the configuration window and all the information.
* Pick the first option to migrate the tables
* Restart the goanywhere service.

* validate database was changed.
* validate data was moved successfully

```sql
USE gadata;
SHOW TABLES;
SELECT * FROM dpa_username LIMIT 10;
```


Lessons Learned:

* Need to review logs in order to check if service is active.

