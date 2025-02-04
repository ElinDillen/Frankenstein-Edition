<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    
    <!-- <xsl:output method="xml" omit-xml-declaration="yes" indent="yes" /> -->
    <xsl:template match="tei:teiHeader"/>

<!-- span class=-->
    <xsl:template match="tei:body">
        <div class="row">
        <div class="col-3"><br/><br/><br/><br/><br/>
        <span class="marginText">
            <xsl:for-each select="//tei:add[@place = 'marginleft']">
                <xsl:choose>
                    <xsl:when test="parent::tei:del">
                        <del>
                            <xsl:attribute name="class">
                                <xsl:value-of select="attribute::hand"/>
                            </xsl:attribute>
                            <xsl:value-of select="."/></del><br/>
                    </xsl:when>
                    <xsl:otherwise>
                        <span >
                            <xsl:attribute name="class">
                                <xsl:value-of select="attribute::hand"/>
                            </xsl:attribute>
                        <xsl:apply-templates/><br/>
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each> 
        </span>
        </div>
        <div class="col-9">
            <div class="transcription">
                <xsl:apply-templates select="//tei:div"/>
            </div>
        </div>
        </div> 
    </xsl:template>
    
    <xsl:template match="tei:div">
        <div class="#MWS"><xsl:apply-templates/></div>
    </xsl:template>
    
    <xsl:template match="tei:p">
        <p><xsl:apply-templates/></p>
    </xsl:template>

    <xsl:template match="tei:head">
        <p><xsl:apply-templates/></p>
    </xsl:template>

  
    <xsl:template match="tei:add[@place = 'marginleft']">
        <span class="marginAdd">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:del">
        <del>
            <xsl:attribute name="class">
                <xsl:value-of select="@hand"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </del>
    </xsl:template>
    
    <!-- all the supralinear additions are given in a span with the class supraAdd, make sure to put this class in superscript in the CSS file, -->

     <xsl:template match="tei:add[@place = 'supralinear']">
        <span>
            <xsl:attribute name="class">
                <xsl:text>supraAdd </xsl:text>
                <xsl:value-of select="@hand"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    
    <!-- add additional templates below, for example to transform the tei:lb in <br/> empty elements, tei:hi[@rend = 'sup'] in <sup> elements, the underlined text, additions with the attribute "overwritten" etc. -->
    <xsl:template match="tei:lb">
        <span class="lineBreak">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:l">
        <span class="lineBreak">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:l[@rend='indent']">
        <span class="indent">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:hi[@rend='sup']">
        <span class="supraAdd">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:hi[@rend='sub']">
        <span class="infralinear">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:hi[@rend='u']">
        <span class="underline">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:hi[@rend='circled']">
        <span class="circled">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:metamark[@function='pagenumber']">
        <span class="pagenumber">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:metamark[@function='pagetitle']">
        <span class="pagetitle">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="nav[@class='navbar navbar-expand-lg navbar-light bg-light']">
        <span class="navbar">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="div[@class='form-group']">
        <span class="navbar">
            <xsl:apply-templates/>
        </span>
    </xsl:template>


    <xsl:template match="tei:add[@place = 'overwritten']">
        <span>
            <xsl:attribute name="class">
                <xsl:text>overwritten </xsl:text>
                <xsl:value-of select="@hand"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:add[@place = 'intralinear']">
        <span>
            <xsl:attribute name="class">
                <xsl:text>intralinear </xsl:text>
                <xsl:value-of select="@hand"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
     <xsl:template match="tei:add[@place = 'infralinear']">
        <span>
            <xsl:attribute name="class">
                <xsl:text>infralinear </xsl:text>
                <xsl:value-of select="@hand"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:note[@type='editorial']">
        <span class="editorial">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:list">
        <ul class="no_bull">
            <xsl:apply-templates select="tei:item" />
        </ul>
    </xsl:template>

    <xsl:template match="tei:item">
        <li>
            <xsl:choose>
                <xsl:when test="@rend='right'">
                    <span class="right">
                        <xsl:apply-templates/>
                    </span>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </li>
    </xsl:template>

    <xsl:template match="tei:choice">
     <xsl:message>Matched <tei:choice> element</xsl:message>
        <span class="choice">
            <span class="sic">
                <xsl:value-of select="tei:sic"/>
            </span>
            <span class="corr">
                (corrected to <xsl:value-of select="tei:corr"/>)
            </span>
        </span>
    </xsl:template>

    <xsl:template match="tei:choice">
        <span class="choice">
            <span class="sic">
                <xsl:apply-templates select="tei:sic"/>
            </span>
            <span class="corr">
                <xsl:apply-templates select="tei:corr"/>
            </span>
        </span>
    </xsl:template>
        
</xsl:stylesheet>
