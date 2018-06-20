<#assign licenseFirst = "/*">
<#assign licensePrefix = " * ">
<#assign licenseLast = " */">

<#if package?? && package != "">
package ${package};

</#if>

import DAO.DAO${clase};
import Util.HibernateUtil;
import java.io.Serializable;
import java.util.List;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
import modelo.${clase};
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TCERO
 */
@ManagedBean(name = "bean${clase}")
@ViewScoped
public class Bean${clase} implements Serializable {
    
    private Session sesion;
    private Transaction transaccion;
    private List<${clase}> ${clasevar};
    private ${clase} ${clasevar}seleccionado;
    
    public Bean${clase}() {
        limpiar${clase}();
        listar();
    }
    
    public void limpiar${clase}(){
        ${clasevar}seleccionado = new ${clase}();
    }
    
    public void listar() {
        try {
            sesion = HibernateUtil.getSessionFactory().openSession();
            transaccion = sesion.beginTransaction();
            DAO${clase} dao${clasevar} = new DAO${clase}();
            ${clasevar} = dao${clasevar}.listar(sesion);
            transaccion.commit();
        } catch (Exception e) {
            if (transaccion != null) {
                transaccion.rollback();
            }
        } finally {
            if (sesion != null) {
                sesion.close();
            }
        }
    }
    
    public void crear() {
        try {
            sesion = HibernateUtil.getSessionFactory().openSession();
            transaccion = sesion.beginTransaction();
            DAO${clase} dao${clasevar} = new DAO${clase}();
            if(${clasevar}seleccionado.getId${clasevar}()==null){
            dao${clasevar}.guardar(sesion, ${clasevar}seleccionado);
            } else {
            dao${clasevar}.editar(sesion, ${clasevar}seleccionado);
            }
            transaccion.commit();
            FacesContext.getCurrentInstance()
                    .addMessage("idmsg",
                            new FacesMessage(FacesMessage.SEVERITY_INFO, "Registro Guardado", null));
        } catch (Exception e) {
            if (transaccion != null) {
                transaccion.rollback();
            }
            FacesContext.getCurrentInstance().addMessage("idmsg",
                            new FacesMessage(FacesMessage.SEVERITY_ERROR, "Error", e.getMessage()));
        } finally {
            if (sesion != null) {
                sesion.close();
            }
        }
        listar();
        RequestContext.getCurrentInstance()
                .update(":frm${clase}");
    }
    
    public void borrar() {
        try {
            sesion = HibernateUtil.getSessionFactory().openSession();
            transaccion = sesion.beginTransaction();
            DAO${clase} dao${clasevar} = new DAO${clase}();
            dao${clasevar}.borrar(sesion, ${clasevar}seleccionado);
            transaccion.commit();
            FacesContext.getCurrentInstance()
                    .addMessage("idmsg",
                            new FacesMessage(FacesMessage.SEVERITY_INFO, "Registro Guardado", null));
        } catch (Exception e) {
            if (transaccion != null) {
                transaccion.rollback();
            }
            FacesContext.getCurrentInstance().addMessage("idmsg",
                            new FacesMessage(FacesMessage.SEVERITY_ERROR, "Error", e.getMessage()));
        } finally {
            if (sesion != null) {
                sesion.close();
            }
        }
        listar();
    }

    public List<${clase}> get${clase}() {
        return ${clasevar};
    }

    public void set${clase}(List<${clase}> ${clasevar}) {
        this.${clasevar} = ${clasevar};
    }

    public ${clase} get${clase}seleccionado() {
        return ${clasevar}seleccionado;
    }

    public void set${clase}seleccionado(${clase} ${clasevar}seleccionado) {
        this.${clasevar}seleccionado = ${clasevar}seleccionado;
    }
}
