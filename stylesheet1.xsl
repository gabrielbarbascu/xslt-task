<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:my="http://example.com/my-custom-namespace" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map">

    <!-- Identity template to copy all nodes and attributes -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Template to convert Roman numbers to Arabic numbers -->
    <xsl:template match="roman">
        <xsl:copy>
            <!-- Convert Roman numeral to Arabic numeral -->
            <xsl:variable name="arabicNum" select="my:convert-roman-to-arabic(.)"/>
            <!-- Add Roman numeral -->
            <xsl:copy-of select="."/>
            <!-- Add Arabic numeral -->
            <arab><xsl:value-of select="$arabicNum"/></arab>
        </xsl:copy>
    </xsl:template>

    <!-- Function to convert Roman numeral to Arabic numeral -->
    <xsl:function name="my:convert-roman-to-arabic">
        <xsl:param name="roman" as="xs:string"/>
        <xsl:variable name="uppercaseRoman" select="upper-case($roman)"/>

        <!-- Lookup table for Roman to Arabic conversion -->
        <xsl:variable name="romanValues" as="map(*)">
            <map>
                <entry key="M" value="1000"/>
                <entry key="CM" value="900"/>
                <entry key="D" value="500"/>
                <entry key="CD" value="400"/>
                <entry key="C" value="100"/>
                <entry key="XC" value="90"/>
                <entry key="L" value="50"/>
                <entry key="XL" value="40"/>
                <entry key="X" value="10"/>
                <entry key="IX" value="9"/>
                <entry key="V" value="5"/>
                <entry key="IV" value="4"/>
                <entry key="I" value="1"/>
            </map>
        </xsl:variable>

        <!-- Iterate through each Roman character and accumulate the Arabic value -->
        <xsl:variable name="arabicValue" as="xs:integer" select="0"/>
        <xsl:for-each select="1 to string-length($uppercaseRoman)">
            <xsl:variable name="currentChar" select="substring($uppercaseRoman, ., 1)"/>
            <xsl:variable name="currentValue" select="map:get($romanValues, $currentChar)"/>
            <xsl:variable name="nextChar" select="substring($uppercaseRoman, position() + 1, 1)"/>
            <xsl:variable name="nextValue" select="map:get($romanValues, $nextChar)"/>

            <xsl:choose>
                <xsl:when test="$currentValue &lt; $nextValue">
                    <xsl:variable name="arabicValue" select="$arabicValue - $currentValue"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="arabicValue" select="$arabicValue + $currentValue"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>

        <!-- Return the accumulated Arabic value -->
        <xsl:sequence select="$arabicValue"/>
    </xsl:function>

</xsl:stylesheet>
