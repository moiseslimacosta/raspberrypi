# -*- coding: utf-8 -*- 

import MySQLdb as sql

class Rules:
	__description = None
	__preprocess = None
	__postprocess = None
	__query = None
	__message = None
	__output = None
	__active = None


	def connect( self, host, username, password, database ):
		self.connection = sql.connect( host, username, password, database )
		self.cursor = self.connection.cursor()


	def disconnect( self ):
		self.connection.close()


	def get_rule_data( self, ruleid ):
		self.cursor.execute( "select rule_desc \
                              ,      rule_query \
                              ,      rule_message \
                              ,      rule_active \
                              ,      rule_preproc \
                              ,      rule_postproc \
                              from   rules \
                              where  rule_id = {0}".format( ruleid ) )

		row = self.cursor.fetchone()

		self.__description = row[0];
		self.__query = row[1];
		self.__message = row[2];
		self.__active = row[3];
		self.__preprocess = row[4];
		self.__postprocess = row[5];


	def run_rule( self, ruleid ):
		self.get_rule_data( ruleid )

		print self.__description
		print self.__active
		print self.__query
		print self.__message

		# if ( self.__active == 'Y' ):
		# 	/* Clear any previous output */
		# 	$this->__output = NULL;

		# 	/* Execute pre process */
		# 	if ( strlen( self.__preprocess ) > 0 ):
		# 		self.cursor.execute( self.__preprocess )

		# 	/* Execute the actual rule */
		# 	$rule_result = self.cursor.execute( self.__query )

		# 	/* Format the message */
		# 	if ( mysqli_num_rows( $rule_result ) = 1 ):
		# 		self.__output = vsprintf( self.__message, mysqli_fetch_array( $rule_result, MYSQLI_NUM ) )

		# 	/* Execute post process */
		# 	if ( strlen( self.__postprocess ) > 0 ):
		# 		self.cursor.execute( self.__postprocess )

		# 	/* Update last usage timestamp for rule */
		# 	self.cursor.execute( "update rules set rule_last_used=now() where rule_id = {0}".format( ruleid ) )

		# 	/* Result result message */
		# 	return ( strlen( self.__output ) > 0 )

		# /* Return failed indicator */
		# return false;


	def getDescription( self ):
		return self.__description


	def getOutput( self ):
		return self.__output


	def getActive( self ):
		return self.__active


	def __init__( self, host, username, password, database ):
		self.connect( host, username, password, database )


	def __del__( self ):
		self.disconnect()