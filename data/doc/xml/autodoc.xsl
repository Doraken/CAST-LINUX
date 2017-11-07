<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/> 

<xsl:template match="/Library">  

	<html>
		<head>
			<title><xsl:value-of select="/LibraryName"/></title>
			
			<link rel="stylesheet" href="style.css" type="text/css" media="screen"/>
		</head>
		<body>
		<center><H1>manual of : <xsl:value-of select="/Library/LibraryName"/></H1></center>
			<div class="resume">
				
	
				
					<xsl:for-each select="./Function">  
					
						<h1><xsl:value-of select="./FunctionName" /></h1>
						<BR></BR>
						
						<P><h3> Liste of functions dependencies</h3></P>
					    <br>debut</br>
						

						<xsl:for-each select="./DependOn"> 
						<Table border="1">
						<TR><TD>Function Name</TD><TD>Source Lib</TD></TR>
						    <xsl:for-each select="./FunctionDepend">  
								<xsl:apply-templates select="." />
							</xsl:for-each>
												</Table>
						</xsl:for-each>

	
																		    <br>Fin</br>	
                        <br></br>

                        <xsl:for-each select="./DocText"> 
                  			<xsl:apply-templates select="." />
       					</xsl:for-each>
					</xsl:for-each>
			
			
			</div>
			
		</body>
	</html>
 
</xsl:template>  
<xsl:template match="FunctionDepend"> 
							<TR>
								<TD><xsl:value-of select="FunctionName" /></TD>
								<TD><xsl:value-of select="FunctionLib" /></TD>
							</TR>
</xsl:template>

<xsl:template match="DocText">
      <P><H3>manual : </H3></P>
      <TABLE>
		<TR>
			<TD><xsl:value-of select="." /></TD>
       	</TR>
      </TABLE>
</xsl:template>
</xsl:stylesheet>