CREATE DATABASE CSC4710;

USE CSC4710;

CREATE USER 'csc4710' IDENTIFIED BY 'password';

GRANT all on *.* to 'csc4710';


CREATE USER 'grafana' IDENTIFIED BY 'grafana';

GRANT SELECT on *.* to 'grafana';
