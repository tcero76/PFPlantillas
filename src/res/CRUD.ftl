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
                    <h:form id="frm${clase}" enctype="multipart/form-data">
                        <p:commandButton value="Nuevo"
                                         icon="ui-icon-newwin"
                                         actionListener="${beanclaselimpiar}"
                                         oncomplete="PF('dialog${clase}Create').show()"
                                         update=":frmCrea${clase}"/>
                        <p:dataTable id="tbl${clase}"
                                     value="${listado}"
                                     var="Item">
                            <p:column headerText="Id" style="text-align: center">
                                <p:outputLabel/>  
                            </p:column>
                            <p:column style="width: 90px">
                                <p:commandButton icon="ui-icon-pencil"
                                                 actionListener="${setearlistado}"
                                                 oncomplete="PF('dialog${clase}Create').show();"
                                                 update=":frmCrea${clase}:idPanelCrear" process="@this"/>
                                <p:commandButton  id="btnEliminarTipoprenda"
                                                  process="@this" icon="ui-icon-close"
                                                  oncomplete="PF('deleted${clase}Dlg').show();"
                                                  actionListener="${setearlistado}">
                                </p:commandButton>
                            </p:column>
                        </p:dataTable>
                    </h:form>
                    <h:form>
                        <p:dialog header="Confirmación de Eliminado" widgetVar="deleted${clase}Dlg" resizable="false">  
                            <h:panelGroup layout="block" style="padding:5px;">  
                                <h:outputText value="¿Está seguro que desea eliminar este registro?"/>  
                            </h:panelGroup>  
                            <p:commandButton id="delete${clase}Btn" value="Eliminar" 
                                             update=":frm${clase}" onclick="PF('deleted${clase}Dlg').hide();"
                                             actionListener="${borrar}"/>
                            <p:commandButton value="Cancel" type="button" onclick="PF('deleted${clase}Dlg').hide();"/>
                        </p:dialog>
                    </h:form>
                    <p:dialog id="dlg${clase}Create" header="Crear Documento" widgetVar="dialog${clase}Create" modal="true" showEffect="fade"
                              hideEffect="explode" resizable="false" closeOnEscape="true">                    
                        <h:form id="frmCrea${clase}">
                            <p:messages/>
                            <p:panelGrid id="idPanelCrear" columns="2" columnClasses="label,value">
                                <p:commandButton value="Crear" process="@this" accesskey="btn_to_enter"
                                                 onclick="PF('dialog${clase}Create').hide();"
                                                 actionListener="${crear}">
                                </p:commandButton>
                            </p:panelGrid>
                        </h:form>
                    </p:dialog>
                </h:body>
            </f:view>
        </ui:define>
    </ui:composition>
    <script type="text/javascript">
        PrimeFaces.locales['es'] = {
            closeText: 'Cerrar',
            prevText: 'Anterior',
            nextText: 'Siguiente',
            monthNames: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
            monthNamesShort: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
            dayNames: ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'],
            dayNamesShort: ['Dom', 'Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab'],
            dayNamesMin: ['D', 'L', 'M', 'X', 'J', 'V', 'S'],
            weekHeader: 'Semana',
            firstDay: 1,
            isRTL: false,
            showMonthAfterYear: false,
            yearSuffix: '',
            timeOnlyTitle: 'Sólo hora',
            timeText: 'Tiempo',
            hourText: 'Hora',
            minuteText: 'Minuto',
            secondText: 'Segundo',
            currentText: 'Fecha actual',
            ampm: false,
            month: 'Mes',
            week: 'Semana',
            day: 'Día',
            allDayText: 'Todo el día'
        };
    </script>
</html>