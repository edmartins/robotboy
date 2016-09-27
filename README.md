# Robotboy

The Robotboy is an email alert from SQL queries.

## Pre-requisites

Ruby-2.2.2 or greater

Mysql table ```accounts``` with this specifc data (**only for rspec and examples below**)

| id    | name  |
| ----- | ----- |
| 1227  | Demo  |
| 1285  | Demo2 |

## Usage

  First of all, configure ```config/mail.yml``` file:

  ```yaml
  address: "smtp.sendgrid.net"
  port: 587
  domain: <domain>
  user_name: <user_name>
  password: <password>
  authentication: 'plain'
  ```
  
  You can see how configure this at this link [mikel/mail](https://github.com/mikel/mail)

  ### Basic (text mode)

  Create a file in ```config/queries/<sql_file_name>.sql```:

  ```sql
  select id, name from accounts where id = 1227;
  ```

  Create a file in ```config/options/<yaml_file_name>.yml```:
  
  ```yaml
  database:
    adapter: mysql2
    host: <host>
    port: <port>
    username: <username>
    password: <password>
    database: <database>
  query:
    file: <sql_file_name>.sql
    results_format: "size"
    alert_condition: "> 0"
  email:
    from: <email>
    to: "<email_1>, <email_2>"
    cc: "<email_3>, <email_4>"
    subject: "Alert: 1 account found!"
  ```

  **Running alert task**

    $ bundle exec rake query_alert option=<yaml_file_name>

  An alert will be sent by email

  ### Report (xls mode)

  Create a file in ```config/queries/<sql_file_name>.sql```:

  ```sql
  select id, name from accounts where id = 1227;
  ```

  Create a file in ```config/options/<yaml_file_name>.yml```:
  
  ```yaml
  database:
    adapter: mysql2
    host: <host>
    port: <port>
    username: <username>
    password: <password>
    database: <database>
  query:
    file: <sql_file_name>.sql
    results_format: "xls"
  email:
    from: <email>
    to: "<email_1>, <email_2>"
    cc: "<email_3>, <email_4>"
    subject: "Accounts report"
    body: "Dear,\n\nfollowing the report.\n\nBest regards,"
  ```

  **Running alert task**

    $ bundle exec rake query_alert option=<yaml_file_name>

  A report will be sent by email

  ### With params (in .yml file)

  Create a file in ```config/queries/<sql_file_name>.sql```:

  ```sql
  select id, name from accounts where id = @@0@@;
  ```

  > Note: watch out for ```@@0@@```.

  Create a file in ```config/options/<yaml_file_name>.yml```:
  
  ```yaml
  database:
    adapter: mysql2
    host: <host>
    port: <port>
    username: <username>
    password: <password>
    database: <database>
  query:
    file: <sql_file_name>.sql
    params: 
      - <account_id>
    results_format: "size"
    alert_condition: "== 1"
  email:
    from: <email>
    to: "<email_1>, <email_2>"
    cc: "<email_3>, <email_4>"
    subject: "Alert: 1 account found!"
  ```

  > Remember ```@@0@@```? they are in the yaml file at params option

  **Running alert task**

    $ bundle exec rake query_alert option=<yaml_file_name>

  An alert will be sent by email

  ### With params (env var)

  Create a file in ```config/queries/<sql_file_name>.sql```:

  ```sql
  select id, name from accounts where id = @@0@@ or id = @@1@@;
  ```

  > Note: watch out for ```@@0@@``` and ```@@1@@```.

  Create a file in ```config/options/<yaml_file_name>.yml```:

  ```yaml
  database:
    adapter: mysql2
    host: <host>
    port: <port>
    username: <username>
    password: <password>
    database: <database>
  query:
    file: <sql_file_name>.sql
    results_format: "size"
    alert_condition: "== 2"
  email:
    from: <email>
    to: "<email_1>, <email_2>"
    cc: "<email_3>, <email_4>"
    subject: "Alert: 2 accounts found!"
  ```

  **Run alert task**

    $ bundle exec rake query_alert option=<yaml_file_name> params="<first_account_id>,<second_account_id>"
    
  > Remember ```@@0@@``` and ```@@1@@```? they are parsed in params environment variable

  An alert will be sent by email

### YAML file combinations

  The possible combinations from ```results_format``` are:
  - ```xls```
  - ```size```
  - ```count```

  ```size``` and ```count``` can be used with ```alert_condition``` option, the possible combinations are:
  - ```> [some_value]```
  - ```>= [some_value]```
  - ```< [some_value]```
  - ```<= [some_value]```
  - ```== [some_value]```
  - ```!= [some_value]```

## Rspec

The rspec need a configure file config/test.yml

> Remeber, you need a ```accounts``` table at mysql

```yaml
database:
  adapter: "mysql2"
  host: <host>
  port: <port>
  username: <username>
  password: <password>
  database: <database>
mail:
  basic_test:
    from: <foo@bar.com.br>
    to: <foo@bar.com.br>
    subject: "select"
    query: "select id, name from accounts where id = 1227;"
    expected_result: "id;name\n1227;demo\n"
  xls_test:
    from: <foo@bar.com.br>
    to: <foo@bar.com.br>
    subject: "Report"
    body: "Dear,\n\nfollowing the report.\n\nBest regards,"
    query: "select id, name from accounts where id = 1227;"
    expected_result: "id;name\n1227;demo\n"
  params_test:
    params: "1227,1285"
```

## Know issues

- The file lib/robotboy/query_alert.rb has a fault sql injection (eval method)

## Future work

- Accept other connectors (sqlite3, etc)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/edmartins/robotboy.

