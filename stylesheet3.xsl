<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Identity template to copy all nodes and attributes -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Template to transform Roman numerals to Arabic -->
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

  <!-- Template to transform Arabic numerals to Roman -->
  <xsl:template match="arab">
    <xsl:copy>
      <xsl:value-of select="arabic-to-roman(.)"/>
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

  <!-- Function to convert Arabic numeral to Roman numeral -->
  <xsl:function name="my:arabic-to-roman">
    <xsl:param name="number" as="xs:integer"/>
    <xsl:variable name="roman-numerals" as="element(numeral)*">
      <numeral value="1000" letter="M"/>
      <numeral value="900" letter="CM"/>
      <numeral value="500" letter="D"/>
      <numeral value="400" letter="CD"/>
      <numeral value="100" letter="C"/>
      <numeral value="90" letter="XC"/>
      <numeral value="50" letter="L"/>
      <numeral value="40" letter="XL"/>
      <numeral value="10" letter="X"/>
      <numeral value="9" letter="IX"/>
      <numeral value="5" letter="V"/>
      <numeral value="4" letter="IV"/>
      <numeral value="1" letter="I"/>
    </xsl:variable>
    <xsl:variable name="result" select="for $num in $roman-numerals return
      if ($number >= $num/@value) then
        concat($num/@letter, my:arabic-to-roman($number - $num/@value))
      else ()"/>
    <xsl:sequence select="string-join($result, '')"/>
  </xsl:function>

</xsl:stylesheet>
