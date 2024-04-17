<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Identity template to copy all nodes and attributes -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Template to convert Roman numbers to Arabic numbers -->
  <xsl:template match="roman">
    <xsl:copy>
      <xsl:variable name="arabicNum" select="roman-to-arabic(.)"/>
      <xsl:choose>
        <!-- Check if the Roman numeral is invalid -->
        <xsl:when test="$arabicNum = -1">
          <xsl:message terminate="yes">Invalid Roman numeral: <xsl:value-of select="."/></xsl:message>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$arabicNum"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <!-- Function to convert Roman numeral to Arabic numeral -->
  <xsl:function name="my:roman-to-arabic">
    <xsl:param name="roman" as="xs:string"/>
    <xsl:variable name="uppercaseRoman" select="upper-case($roman)"/>
    <xsl:variable name="romanValues" as="element()*">
      <numeral letter="M" value="1000"/>
      <numeral letter="D" value="500"/>
      <numeral letter="C" value="100"/>
      <numeral letter="L" value="50"/>
      <numeral letter="X" value="10"/>
      <numeral letter="V" value="5"/>
      <numeral letter="I" value="1"/>
    </xsl:variable>
    <xsl:variable name="romanLength" select="string-length($uppercaseRoman)"/>
    <xsl:variable name="values" as="xs:integer*">
      <xsl:for-each select="1 to $romanLength">
        <xsl:variable name="char" select="substring($uppercaseRoman, ., 1)"/>
        <xsl:value-of select="if ($char = 'M') then 1000
                            else if ($char = 'D') then 500
                            else if ($char = 'C') then 100
                            else if ($char = 'L') then 50
                            else if ($char = 'X') then 10
                            else if ($char = 'V') then 5
                            else if ($char = 'I') then 1
                            else 0"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="result" as="xs:integer">
      <xsl:for-each select="1 to $romanLength">
        <xsl:choose>
          <xsl:when test="$values[position() = $romanLength] &gt;= $values[position() + 1]">
            <xsl:value-of select="$values[position()]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="-$values[position()]"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="matches($uppercaseRoman, '^(M|D?C{0,3})(C|L?X{0,3})(X|V?I{0,3})$')">
        <xsl:sequence select="$result"/>
      </xsl:when>
      <xsl:otherwise>-1</xsl:otherwise><!-- Invalid Roman numeral -->
    </xsl:choose>
  </xsl:function>

</xsl:stylesheet>
