<?xml version='1.0' encoding='UTF-8' ?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:h="http://java.sun.com/jsf/html"
      xmlns:p="http://primefaces.org/ui"  
      xmlns:f="http://java.sun.com/jsf/core"
      xmlns:pe="http://primefaces.org/ui/extensions"
      xmlns:ui="http://xmlns.jcp.org/jsf/facelets">
    <ui:composition template="./../Plantilla.xhtml">
        <ui:define name="content">
            <f:view contentType="text/html" locale="es">
                <h:head>
                    <title>${title}</title>
                </h:head>
                <h:body>
                    <p:growl id="idmsg" showDetail="true" />
                    <h:form id="frm${detalle}" enctype="multipart/form-data">
                        <pe:masterDetail id="masterDetail" level="${beanmastercurrentLevel}">
                            <pe:masterDetailLevel level="1"  levelLabel="Ordenes de Trabajo">
                                <p:commandButton value="Nuevo" accesskey="btn_to_enter"
                                                 actionListener="${beanmasterlimpiar}">
                                    <pe:selectDetailLevel contextValue="${beanmasterseleccionado}"/>
                                </p:commandButton>
                                <p:dataTable id="tbl${detalle}"
                                             value="${listadomaestro}"
                                             var="Item">
                                    <p:column headerText="${maestro}" style="text-align: center">
                                        <p:commandLink value="${Itemidmaster}">  
                                            <f:setPropertyActionListener value="${Item}"
                                                                         target="${beanmasterseleccionado}"/>
                                            <pe:selectDetailLevel contextValue="${Item}"/>
                                        </p:commandLink> 
                                    </p:column>
                                </p:dataTable>
                            </pe:masterDetailLevel>  
                            <pe:masterDetailLevel level="2" contextVar="${maestro}"
                                                  levelLabel="Referencia uno"> 
                                <p:panelGrid id="idpnl1">
                                    <f:facet name="header">
                                        <p:row>
                                            <p:column colspan="4">
                                                ${title}
                                            </p:column>
                                        </p:row>
                                        <p:row>
                                            <p:column colspan="4" >
                                                <p:messages/>
                                            </p:column>
                                        </p:row>
                                    </f:facet>

                                    <p:row>
                                        <p:column colspan="4" >
                                            <p:dataTable var="Item"
                                                         value="${listadodetalle}">
                                                <p:column headerText="N� Item">
                                                    <p:commandLink value="${iddetalle}">
                                                        <f:setPropertyActionListener value="${Item}"
                                                                                     target="${detalleseleccionar}"/>
                                                        <pe:selectDetailLevel contextValue="${Item}"/>
                                                    </p:commandLink>
                                                </p:column>
                                                <f:facet name="footer">
                                                    <p:commandButton value="Nuevo" accesskey="btn_to_enter"
                                                                    process="@this"
                                                                    update=":growl, :frm${detalle}:masterDetail"
                                                                     actionListener="${detallelimpiar}">
                                                        <pe:selectDetailLevel contextValue="${detalleseleccionar}"/>
                                                    </p:commandButton>
                                                </f:facet>
                                            </p:dataTable>
                                        </p:column>
                                    </p:row>
                                    <f:facet name="footer">
                                        <p:row>
                                            <p:column colspan="4">
                                                <p:commandButton id="idbtnguardar" value="Guardar" process="@form" 
                                                                 update=":growl"
                                                                 actionListener="${guardarmaster}">
                                                    <pe:selectDetailLevel level="1"/> 
                                                </p:commandButton>
                                                <p:commandButton id="idbtnborrar" value="Borrar" process="@form" 
                                                                 update=":growl, :frm${detalle}:masterDetail"
                                                                 actionListener="${borrarmaster}">
                                                    <pe:selectDetailLevel level="1"/> 
                                                </p:commandButton>
                                            </p:column>
                                        </p:row>
                                    </f:facet>
                                </p:panelGrid>
                            </pe:masterDetailLevel>
                            <pe:masterDetailLevel level="3" contextVar="variable"
                                                  levelLabel="N� Item ${detalleseleccionar}">
                                <p:panelGrid id="idpnl2">
                                    <f:facet name="header">
                                        <p:row>
                                            <p:column colspan="4">
                                                ${maestro}  
                                            </p:column>
                                        </p:row>
                                        <p:row>
                                            <p:column colspan="4" >
                                                <p:messages/>
                                            </p:column>
                                        </p:row>
                                    </f:facet>
                                    <f:facet name="footer">
                                        <p:row>
                                            <p:column colspan="4">
                                                <p:commandButton id="idGrabarOt${detalle}" value="Grabar"
                                                                 process="@form" accesskey="btn_to_enter"
                                                                 update=":growl"
                                                                 actionListener="${guardardetalle}">
                                                    <pe:selectDetailLevel level="2"/>
                                                </p:commandButton>
                                                <p:commandButton id="idBorrar${detalle}" value="Borrar" process="@form"
                                                                 update=":growl"
                                                                 actionListener="${borrardetalle}">
                                                    <pe:selectDetailLevel level="2"/>
                                                </p:commandButton>
                                                <p:commandButton id="idCancelar${detalle}" value="Cancelar" process="@form">
                                                    <pe:selectDetailLevel level="2"/>
                                                </p:commandButton>
                                            </p:column>
                                        </p:row>
                                    </f:facet>
                                </p:panelGrid>
                            </pe:masterDetailLevel>
                        </pe:masterDetail>
                    </h:form>
                </h:body>

            </f:view>
        </ui:define>
    </ui:composition>
</html>