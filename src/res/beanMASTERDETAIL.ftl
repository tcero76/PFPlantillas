<#assign licenseFirst = "/*">
<#assign licensePrefix = " * ">
<#assign licenseLast = " */">

<#if package?? && package != "">
package ${package};

</#if>
import java.io.Serializable;
import java.util.Date;
import java.util.List;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ManagedProperty;
import javax.faces.bean.ViewScoped;
import javax.faces.context.FacesContext;
import org.hibernate.Session;
import org.hibernate.Transaction;
import modelo.${maestro};
import modelo.${detalle};
import dao.DAO${maestro};
import dao.DAO${detalle};
import utiles.HibernateUtil;

/**
 *
 * @author TCERO
 */
@ManagedBean(name="bean${detalle}")
@ViewScoped
public class Bean${detalle} implements Serializable {
    private Session sesion;
    private Transaction transaccion;
    private List<${maestro}> ${maestrovar};
    private ${maestro} ${maestrovar}seleccionado;
    private List<${detalle}> ${detallevar};
    private ${detalle} ${detallevar}seleccionado;
    private int currentLevel = 1;
    @ManagedProperty(value = "${loginBean}")
    private LoginBean sesionUsuario;

    public Bean${detalle}() {
        listar${maestro}();
    }
    
    public void limpiar${maestro}() {
        ${maestrovar}seleccionado = new ${maestro}();
//        ${maestrovar}.getOtds().clear();
    }
    
    public void limpiar${detalle}() {
        crear${maestro}();
        ${detallevar}seleccionado = new ${detalle}();
        ${maestrovar}seleccionado.get${detalle}s().add(${detallevar}seleccionado);
        ${detallevar}seleccionado.set${maestro}(${maestrovar}seleccionado);
    }
    
    public void listar${maestro}() {
        try {
            sesion = HibernateUtil.getSessionFactory().openSession();
            transaccion = sesion.beginTransaction();
            DAO${maestro} dao${maestrovar} = new DAO${maestro}();
            ${maestrovar} = dao${maestrovar}.listar(sesion);
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
//        if (${maestrovar}seleccionado != null) {
//            for (${maestro} sel : ${maestrovar}) {
//                if (${maestrovar}seleccionado.getId${maestrovar}().equals(sel.getId${maestrovar}())) {
//                    ${maestrovar}seleccionado = sel;
//                }
//            }
//        }
    }
    
    public void crear${maestro}() {
        ${maestrovar}seleccionado.setUsuario(sesionUsuario.getUsuario());
        try {
            sesion = HibernateUtil.getSessionFactory().openSession();
            transaccion = sesion.beginTransaction();
            DAO${maestro} dao${maestrovar} = new DAO${maestro}();
            if (${maestrovar}seleccionado.getId${maestrovar}() == null) {
                ${maestrovar}seleccionado.setFecharegistro(new Date());
                dao${maestrovar}.guardar(sesion,${maestrovar}seleccionado);
            } else {
                ${maestrovar}seleccionado.setFechamodificacion(new Date());
                dao${maestrovar}.editar(sesion,${maestrovar}seleccionado);
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
        listar${maestro}();
        RequestContext.getCurrentInstance()
                .update(":frm${detalle}:masterDetail");
    }
    
    public void crear${detalle}() {
        String usuario = (String) FacesContext.getCurrentInstance().getExternalContext().getSessionMap().get("usuario");
//        otseleccionada.setUsuarios(new Usuarios());
//        otseleccionada.getUsuarios().setIdusuarios(Integer.parseInt(usuario));
        try {
            sesion = HibernateUtil.getSessionFactory().openSession();
            transaccion = sesion.beginTransaction();
            DAO${detalle} dao${detallevar} = new DAO${detalle}();
            if (${detallevar}seleccionado.getId${detallevar}() == null) {
                ${detallevar}seleccionado.setFecharegistro(new Date());
                dao${detallevar}.guardar(sesion,${detallevar}seleccionado);
            } else {
                ${detallevar}seleccionado.setFechamodificacion(new Date());
                dao${detallevar}.editar(sesion,${detallevar}seleccionado);
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
        listar${maestro}();
        RequestContext.getCurrentInstance()
                .update(":frm${detalle}:masterDetail");
    }
    
    public void borrar${maestro}() {
        try {
            sesion = HibernateUtil.getSessionFactory().openSession();
            transaccion = sesion.beginTransaction();
            DAO${maestro} dao${maestrovar} = new DAO${maestro}();
            dao${maestrovar}.borrar(sesion,${maestrovar}seleccionado);
            transaccion.commit();
            FacesContext.getCurrentInstance()
                    .addMessage("idmsg",
                            new FacesMessage(FacesMessage.SEVERITY_INFO, "Registro Borrado", null));
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
        listar${maestro}();
        RequestContext.getCurrentInstance()
                .update(":frm${detalle}:masterDetail");
    }
    
    public void borrar${detalle}() {
        try {
            sesion = HibernateUtil.getSessionFactory().openSession();
            transaccion = sesion.beginTransaction();
            DAO${detalle} dao${detallevar} = new DAO${detalle}();
            dao${detallevar}.borrar(sesion,${detallevar}seleccionado);
            transaccion.commit();
            FacesContext.getCurrentInstance()
                    .addMessage("idmsg",
                            new FacesMessage(FacesMessage.SEVERITY_INFO, "Registro Borrado", null));
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
        listar${maestro}();
        RequestContext.getCurrentInstance()
                .update(":frm${detalle}:masterDetail");
    }


    public List<${maestro}> get${maestro}() {
        return ${maestrovar};
    }

    public void set${maestro}(List<${maestro}> ${maestrovar}) {
        this.${maestrovar} = ${maestrovar};
    }

    public ${maestro} get${maestro}seleccionado() {
        return ${maestrovar}seleccionado;
    }

    public void set${maestro}seleccionado(${maestro} ${maestrovar}seleccionado) {
        this.${maestrovar}seleccionado = ${maestrovar}seleccionado;
    }

    public List<${detalle}> get${detalle}() {
        return ${detallevar};
    }

    public void set${detalle}(List<${detalle}> ${detallevar}) {
        this.${detallevar} = ${detallevar};
    }

    public ${detalle} get${detalle}seleccionado() {
        return ${detallevar}seleccionado;
    }

    public void set${detalle}seleccionado(${detalle} ${detallevar}seleccionado) {
        this.${detallevar}seleccionado = ${detallevar}seleccionado;
    }

    public int getCurrentLevel() {
        return currentLevel;
    }

    public void setCurrentLevel(int currentLevel) {
        this.currentLevel = currentLevel;
    }

    public void setSesionUsuario(LoginBean sesionUsuario) {
        this.sesionUsuario = sesionUsuario;
    }
}