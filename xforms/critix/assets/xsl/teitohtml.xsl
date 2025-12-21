<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="1.0">

    <xsl:output encoding="UTF-8" method="html" indent="yes"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:TEI">
        <div id="content">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:teiHeader"/>

    <xsl:template match="tei:p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:app">
        <span class="app" id="{ ./@xml:id }"><xsl:apply-templates/></span>
    </xsl:template>
    
    <xsl:template match="tei:lem">
        <span class="lem" id="{ ./@xml:id }"><span style="cursor: pointer;" onclick="review('{ parent::tei:app/@xml:id }', '{ ./@xml:id }')"><xsl:apply-templates/></span></span>
    </xsl:template>
    
    <xsl:template match="tei:rdg">
        <span class="rdg" id="{ ./@xml:id }"><span style="cursor: pointer;" onclick="review('{ parent::tei:app/@xml:id }', '{ ./@xml:id }')"><xsl:apply-templates/></span></span>
    </xsl:template>
    
</xsl:stylesheet>
