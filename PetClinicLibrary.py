import mysql.connector
from robot.api.deco import keyword
import sqlalchemy
from sqlalchemy.sql import text
import requests

class PetClinicLibrary(object):

    def __init__(self):
        test = "test"

    @keyword("Owner Should Be In Database")
    def owner_db(self, first_name, last_name, address, city, telephone):
        """Check that owner exists in the database"""
        conn = mysql.connector.connect(user="root", password="test1234",
                                       host="localhost",
                                       database="petclinic")
        cursor = conn.cursor(dictionary=True)

        query = ("SELECT * FROM owners WHERE (first_name = '{}' "
                 "AND last_name = '{}' AND address = '{}' AND city = '{}' "
                 "AND telephone = '{}')".format(first_name, last_name, address, city, str(telephone)))
        cursor.execute(query)

        row = cursor.fetchone()
        if row is None:
            raise AssertionError("Owner not found in database.")

        conn.close()

        return row['id']

    @keyword("Owner Should Not Be In Database")
    def owner_no(self, first_name, last_name, address, city, telephone):
        """Check that owner exists in the database"""
        conn = mysql.connector.connect(user="root", password="test1234",
                                       host="localhost",
                                       database="petclinic")
        cursor = conn.cursor(dictionary=True)

        query = ("SELECT * FROM owners WHERE (first_name = '{}' "
                 "AND last_name = '{}' AND address = '{}' AND city = '{}' "
                 "AND telephone = '{}')".format(first_name, last_name, address, city, str(telephone)))
        cursor.execute(query)

        row = cursor.fetchone()
        if row is not None:
            raise AssertionError("Owner was found in database.")

        conn.close()

    @keyword("Pet Should Be In Database")
    def pet_db(self, name, birth_date, pet_type, owner_id):
        """Check that pet exists in the database"""
        conn = mysql.connector.connect(user="root", password="test1234",
                                       host="localhost",
                                       database="petclinic")
        cursor = conn.cursor(dictionary=True)

        query = ("SELECT id FROM types WHERE name = '{}'".format(pet_type))
        cursor.execute(query)

        row = cursor.fetchone()
        if row is None:
            raise AssertionError("Pet type ID not found.")
        type_id = row['id']

        query = ("SELECT * FROM pets WHERE (name = '{}' "
                 "AND birth_date = '{}' AND type_id = '{}' "
                 "AND owner_id = '{}')".format(name, birth_date, type_id, owner_id))
        cursor.execute(query)

        row = cursor.fetchone()
        if row is None:
            raise AssertionError("Pet not found in database.")

        conn.close()

        return row['id']

    @keyword("Pet Should Not Be In Database")
    def pet_no(self, name, birth_date, pet_type, owner_id):
        """Check that pet exists in the database"""
        conn = mysql.connector.connect(user="root", password="test1234",
                                       host="localhost",
                                       database="petclinic")
        cursor = conn.cursor(dictionary=True)

        query = ("SELECT id FROM types WHERE name = '{}'".format(pet_type))
        cursor.execute(query)

        row = cursor.fetchone()
        if row is None:
            raise AssertionError("Pet type ID not found.")
        type_id = row['id']

        query = ("SELECT * FROM pets WHERE (name = '{}' "
                 "AND birth_date = '{}' AND type_id = '{}' "
                 "AND owner_id = '{}')".format(name, birth_date, type_id, owner_id))
        cursor.execute(query)

        row = cursor.fetchone()
        if row is not None:
            raise AssertionError("Pet was found in database.")

        conn.close()

    @keyword("Visit Should Be In Database")
    def visit_db(self, pet_id, visit_date, visit_desc):
        """Check that visit exists in the database"""
        conn = mysql.connector.connect(user="root", password="test1234",
                                       host="localhost",
                                       database="petclinic")
        cursor = conn.cursor(dictionary=True)

        query = ("SELECT * FROM visits WHERE (pet_id = '{}' "
                 "AND visit_date = '{}' "
                 "AND description = '{}')".format(pet_id, visit_date, visit_desc))
        cursor.execute(query)

        row = cursor.fetchone()
        if row is None:
            raise AssertionError("Visit not found in database.")

        conn.close()

        return row['id']

    @keyword("Visit Should Not Be In Database")
    def visit_no(self, pet_id, visit_date, visit_desc):
        """Check that visit exists in the database"""
        conn = mysql.connector.connect(user="root", password="test1234",
                                       host="localhost",
                                       database="petclinic")
        cursor = conn.cursor(dictionary=True)

        query = ("SELECT * FROM visits WHERE (pet_id = '{}' "
                 "AND visit_date = '{}' "
                 "AND description = '{}')".format(pet_id, visit_date, visit_desc))
        cursor.execute(query)

        row = cursor.fetchone()
        if row is not None:
            raise AssertionError("Visit was found in database.")

        conn.close()

    @keyword("Restore Database")
    def restore_db(self):
        """Restore database dump"""
        db_name = 'petclinic'
        db_schema = 'F:\\Projects\\petclinic_robot\\schema.sql'
        db_data = 'F:\\Projects\\petclinic_robot\\data.sql'

        engine = sqlalchemy.create_engine('mysql://root:test1234@127.0.0.1:3306')
        engine.execute('DROP DATABASE IF EXISTS {};'.format(db_name))
        conn = engine.connect()

        sql_file = open(db_schema, 'r')
        sql_command = ''
        for line in sql_file:
            if not line.startswith('--') and line.strip('\n'):
                sql_command += line.strip('\n')
                if sql_command.endswith(';'):
                    try:
                        conn.execute(text(sql_command))
                        conn.commit()
                    except:
                        print('Failed SQL row: {}'.format(sql_command))
                    finally:
                        sql_command = ''

        sql_file = open(db_data, 'r')
        sql_command = ''
        for line in sql_file:
            if not line.startswith('--') and line.strip('\n'):
                sql_command += line.strip('\n')
                if sql_command.endswith(';'):
                    try:
                        conn.execute(text(sql_command))
                        conn.commit()
                    except:
                        print('Ops: {}'.format(sql_command))
                    finally:
                        sql_command = ''
        conn.close()

    @keyword("Create Owner Through API")
    def owner_api(self, firstname, lastname, address, city, telephone):
        """Create a owner through the API"""
        data = {'firstName': '{}'.format(firstname), 'lastName': '{}'.format(lastname),
                'address': '{}'.format(address), 'city': '{}'.format(city),
                'telephone': '{}'.format(telephone)}
        r = requests.post('http://localhost:8081/owners/new', data)

        if r.status_code != 200:
            raise AssertionError("Creating a owner through API failed.")

    @keyword("Create Pet Through API")
    def pet_api(self, name, bdate, type, owner_id):
        """Create a pet through the API"""
        data = {'name': '{}'.format(name), 'birthDate': '{}'.format(bdate),
                'type': '{}'.format(type)}
        r = requests.post('http://localhost:8081/owners/{}/pets/new'.format(owner_id),
                          data)

        if r.status_code != 200:
            raise AssertionError("Creating a pet through API failed.")

    @keyword("Create Visit Through API")
    def visit_api(self, date, description, pet_id, owner_id):
        """Create a visit through the API"""
        data = {'date': '{}'.format(date), 'description': '{}'.format(description),
                'petId': '{}'.format(pet_id)}
        r = requests.post('http://localhost:8081/owners/{}/pets/{}/visits/new'.format(owner_id, pet_id),
                          data)

        if r.status_code != 200:
            raise AssertionError("Creating a pet through API failed.")