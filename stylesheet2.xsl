<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Identity template to copy all nodes and attributes -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Template to convert Arabic numbers to Roman numbers -->
  <xsl:template match="arab">
    <xsl:copy>
      <xsl:value-of select="arabic-to-roman(.)"/>
    </xsl:copy>
  </xsl:template>

  <!-- Function to convert Arabic numeral to Roman numeral -->
  <xsl:function name="my:arabic-to-roman">
    <xsl:param name="arabic" as="xs:integer"/>
    <xsl:choose>
      <xsl:when test="$arabic &lt;= 0 or $arabic &gt;= 4000">
        <xsl:value-of select="'Invalid'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="to-roman">
          <xsl:with-param name="number" select="$arabic"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!-- Template to recursively convert Arabic number to Roman number -->
  <xsl:template name="to-roman">
    <xsl:param name="number" as="xs:integer"/>
    <xsl:param name="ones" select="'I'"/>
    <xsl:param name="fives" select="'V'"/>
    <xsl:param name="tens" select="'X'"/>
    <xsl:param name="fifties" select="'L'"/>
    <xsl:param name="hundreds" select="'C'"/>
    <xsl:param name="five_hundreds" select="'D'"/>
    <xsl:param name="thousands" select="'M'"/>
    <xsl:choose>
      <xsl:when test="$number &lt; 4">
        <xsl:value-of select="string-join(for $i in 1 to $number return $ones, '')"/>
      </xsl:when>
      <xsl:when test="$number = 4">
        <xsl:value-of select="concat($ones, $fives)"/>
      </xsl:when>
      <xsl:when test="$number = 5">
        <xsl:value-of select="$fives"/>
      </xsl:when>
      <xsl:when test="$number &gt; 5 and $number &lt; 9">
        <xsl:value-of select="concat($fives, string-join(for $i in 6 to $number return $ones, ''))"/>
      </xsl:when>
      <xsl:when test="$number = 9">
        <xsl:value-of select="concat($ones, $tens)"/>
      </xsl:when>
      <xsl:when test="$number = 10">
        <xsl:value-of select="$tens"/>
      </xsl:when>
      <xsl:when test="$number &gt; 10 and $number &lt; 40">
        <xsl:value-of select="concat(string-join(for $i in 1 to ($number div 10) return $tens, ''), $ones)"/>
        <xsl:call-template name="to-roman">
          <xsl:with-param name="number" select="$number mod 10"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$number &gt;= 40 and $number &lt; 50">
        <xsl:value-of select="concat($tens, $fifties)"/>
        <xsl:call-template name="to-roman">
          <xsl:with-param name="number" select="$number mod 10"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$number &gt;= 50 and $number &lt; 90">
        <xsl:value-of select="concat($fifties, string-join(for $i in 6 to ($number div 10) return $tens, ''), $ones)"/>
        <xsl:call-template name="to-roman">
          <xsl:with-param name="number" select="$number mod 10"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$number &gt;= 90 and $number &lt; 100">
        <xsl:value-of select="concat($tens, $hundreds)"/>
        <xsl:call-template name="to-roman">
          <xsl:with-param name="number" select="$number mod 10"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$number = 100">
        <xsl:value-of select="$hundreds"/>
      </xsl:when>
      <xsl:when test="$number &gt; 100 and $number &lt; 400">
        <xsl:value-of select="concat(string-join(for $i in 1 to ($number div 100) return $hundreds, ''), $tens)"/>
        <xsl:call-template name="to-roman">
          <xsl:with-param name="number" select="$number mod 100"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$number &gt;= 400 and $number &lt; 500">
        <xsl:value-of select="concat($hundreds, $five_hundreds)"/>
        <xsl:call-template name="to-roman">
          <xsl:with-param name="number" select="$number mod 100"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$number &gt;= 500 and $number &lt; 900">
        <xsl:value-of select="concat($five_hundreds, string-join(for $i in 6 to ($number div 100) return $hundreds, ''), $tens)"/>
        <xsl:call-template name="to-roman">
          <xsl:with-param name="number" select="$number mod 100"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$number &gt;= 900 and $number &lt; 1000">
        <xsl:value-of select="concat($hundreds, $thousands)"/>
        <xsl:call-template name="to-roman">
          <xsl:with-param name="number" select="$number mod 100"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$number = 1000">
        <xsl:value-of select="$thousands"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
