<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:my="http://example.com/my-custom-namespace" xmlns:xs="http://www.w3.org/2001/XMLSchema">

    <!-- Identity template to copy all nodes and attributes -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Template to transform Roman numerals to Arabic -->
    <xsl:template match="roman">
        <xsl:copy>
            <xsl:variable name="arabicNum" select="my:roman-to-arabic(.)"/>
            <xsl:variable name="validArabicNum" select="xs:integer($arabicNum)"/>
<xsl:value-of select="$validArabicNum"/>

        </xsl:copy>
    </xsl:template>

    <!-- Template to transform Arabic numerals to Roman -->
    <xsl:template match="arab">
        <xsl:copy>
            <xsl:value-of select="my:arabic-to-roman(xs:integer(.))"/>
        </xsl:copy>
    </xsl:template>

    <!-- Function to convert Roman numeral to Arabic numeral -->
    <xsl:function name="my:roman-to-arabic">
        <xsl:param name="roman" as="xs:string"/>
        <xsl:variable name="romanValues">
            <numeral letter="M" value="1000"/>
            <numeral letter="CM" value="900"/>
            <numeral letter="D" value="500"/>
            <numeral letter="CD" value="400"/>
            <numeral letter="C" value="100"/>
            <numeral letter="XC" value="90"/>
            <numeral letter="L" value="50"/>
            <numeral letter="XL" value="40"/>
            <numeral letter="X" value="10"/>
            <numeral letter="IX" value="9"/>
            <numeral letter="V" value="5"/>
            <numeral letter="IV" value="4"/>
            <numeral letter="I" value="1"/>
        </xsl:variable>

        <xsl:variable name="romanLength" select="string-length($roman)"/>
        <xsl:variable name="values" as="xs:integer*">
            <xsl:for-each select="1 to $romanLength">
                <xsl:variable name="char" select="substring($roman, ., 1)"/>
                <xsl:variable name="value">
                    <xsl:choose>
                        <xsl:when test="$char = 'M'">1000</xsl:when>
                        <xsl:when test="$char = 'CM'">900</xsl:when>
                        <xsl:when test="$char = 'D'">500</xsl:when>
                        <xsl:when test="$char = 'CD'">400</xsl:when>
                        <xsl:when test="$char = 'C'">100</xsl:when>
                        <xsl:when test="$char = 'XC'">90</xsl:when>
                        <xsl:when test="$char = 'L'">50</xsl:when>
                        <xsl:when test="$char = 'XL'">40</xsl:when>
                        <xsl:when test="$char = 'X'">10</xsl:when>
                        <xsl:when test="$char = 'IX'">9</xsl:when>
                        <xsl:when test="$char = 'V'">5</xsl:when>
                        <xsl:when test="$char = 'IV'">4</xsl:when>
                        <xsl:when test="$char = 'I'">1</xsl:when>
                        <xsl:otherwise>0</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:sequence select="$value"/>
            </xsl:for-each>
        </xsl:variable>

        <xsl:variable name="total" select="0"/>
        <xsl:for-each select="1 to $romanLength">
            <xsl:variable name="currentValue" select="$values[position()]"/>
            <xsl:variable name="nextValue" select="if (position() &lt; $romanLength) then $values[position() + 1] else 0"/>
            <xsl:variable name="subtractValue">
                <xsl:choose>
                    <xsl:when test="$currentValue &lt; $nextValue">
                        <xsl:sequence select="-$currentValue"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="$currentValue"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>


<xsl:sequence select="$total + $subtractValue"/>

        </xsl:for-each>
        <xsl:choose>
            <xsl:when test="matches($roman, '^M{0,4}(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3})$')">
                <xsl:sequence select="$total"/>
            </xsl:when>
            <xsl:otherwise>
                <!-- Return a default value (e.g., 0) for invalid Roman numerals -->
                <xsl:sequence select="0"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- Function to convert Arabic numeral to Roman numeral -->
    <xsl:function name="my:arabic-to-roman">
        <xsl:param name="number"/>
        <xsl:variable name="num" as="xs:integer" select="xs:integer($number)"/>
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

        <!-- Recursive conversion from Arabic to Roman -->
        <xsl:variable name="result" select="for $num in $roman-numerals return
            if ($num/@value &lt;= $num) then
                concat($num/@letter, my:arabic-to-roman($num - $num/@value))
            else ()"/>

        <xsl:sequence select="string-join($result, '')"/>
    </xsl:function>

</xsl:stylesheet>
