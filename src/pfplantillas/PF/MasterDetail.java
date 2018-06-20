package pfplantillas.PF;

import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.jface.wizard.Wizard;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.MessageBox;
import org.eclipse.ui.INewWizard;
import org.eclipse.ui.IWorkbench;
import org.eclipse.core.runtime.*;
import org.eclipse.jface.operation.*;
import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.Map;

import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.core.resources.*;

import java.io.*;
import org.eclipse.ui.*;
import org.eclipse.ui.ide.IDE;

import freemarker.template.Configuration;
import freemarker.template.Template;

/**
 * This is a sample new wizard. Its role is to create a new file 
 * resource in the provided container. If the container resource
 * (a folder or a project) is selected in the workspace 
 * when the wizard is opened, it will accept it as the target
 * container. The wizard creates one file with the extension
 * "xhtml". If a sample multi-page editor (also available
 * as a template) is registered for the same extension, it will
 * be able to open it.
 */

public class MasterDetail extends Wizard implements INewWizard {
	private MasterDetailPage page;
	private ISelection selection;

	/**
	 * Constructor for CRUD.
	 */
	public MasterDetail() {
		super();
		setNeedsProgressMonitor(true);
	}
	
	/**
	 * Adding the page to the wizard.
	 */
	@Override
	public void addPages() {
		page = new MasterDetailPage(selection);
		addPage(page);
	}

	/**
	 * This method is called when 'Finish' button is pressed in
	 * the wizard. We will create an operation and run it
	 * using wizard as execution context.
	 */
	@Override
	public boolean performFinish() {
		final String containerName = page.getContainerName();
		final String fileName = page.getFileName();
        String HtmlTitle = page.getTitle();
        String master = page.getMasterText().getText();
        String detalle = page.getDetalleText().getText();
		IRunnableWithProgress op = new IRunnableWithProgress() {
			public void run(IProgressMonitor monitor) throws InvocationTargetException {
				try {
					doFinish(containerName, fileName, HtmlTitle, master, detalle, monitor);
				} catch (CoreException e) {
					throw new InvocationTargetException(e);
				} finally {
					monitor.done();
				}
			}
		};
		try {
			getContainer().run(true, false, op);
		} catch (InterruptedException e) {
			return false;
		} catch (InvocationTargetException e) {
			Throwable realException = e.getTargetException();
			MessageDialog.openError(getShell(), "Error", realException.getMessage());
			return false;
		}
		return true;
	}
	
	/**
	 * The worker method. It will find the container, create the
	 * file if missing or just replace its contents, and open
	 * the editor on the newly created file.
	 */

	private void doFinish(
		String containerName,
		String fileName,
		String HtmlTitle,
		String master, 
		String detalle,
		IProgressMonitor monitor)
		throws CoreException {
		// create a sample file
		monitor.beginTask("Creating " + fileName, 2);
		IWorkspaceRoot root = ResourcesPlugin.getWorkspace().getRoot();
		IResource resource = root.findMember(new Path(containerName));
		if (!resource.exists() || !(resource instanceof IContainer)) {
			throwCoreException("Container \"" + containerName + "\" does not exist.");
		}
		try {

			Map<String, String> args = new HashMap<String, String>();
	        args.put("title", HtmlTitle);
	        args.put("Item", "#{Item}");
	        args.put("Itemidmaster", "#{Item.id" + master + "}");
	        args.put("beanmasterseleccionado", "#{bean" + detalle + "." + 
	                master.substring(0, 1).toLowerCase() + master.substring(1, master.length()) + "seleccionado}");
	        args.put("beanmasterlimpiar", "#{bean" + detalle + ".limpiar" + master + "()}");
	        args.put("beanmastercurrentLevel", "#{bean" + detalle + ".currentLevel}");
	        args.put("maestro", master);
	        args.put("maestrovar", master.substring(0, 1).toLowerCase() + master.substring(1, master.length()));
	        args.put("detalle", detalle);
	        args.put("detallevar", detalle.substring(0, 1).toLowerCase() + detalle.substring(1, detalle.length()));
	        args.put("listadomaestro", "#{bean" + detalle + "." + master.substring(0, 1).toLowerCase()
	                + master.substring(1, master.length()) + "}");
	        args.put("listadodetalle", "#{bean" + detalle + "."
	                + master.substring(0, 1).toLowerCase() + master.substring(1, master.length())
	                + "seleccionado." + detalle.substring(0, 1).toLowerCase() + detalle.substring(1, detalle.length())
	                + "s}");
	        args.put("iddetalle", "#{Item.id" + detalle.substring(0, 1).toLowerCase()
	                + detalle.substring(1, detalle.length()) + "}");
	        args.put("detalleseleccionar", "#{bean" + detalle + "."
	                + detalle.substring(0, 1).toLowerCase() + detalle.substring(1, detalle.length())
	                + "seleccionado}");
	        args.put("detallelimpiar", "#{bean" + detalle + ".limpiar" + detalle + "()}");
	        args.put("guardarmaster", "#{bean" + detalle + ".crear" + master + "()}");
	        args.put("borrarmaster", "#{bean" + detalle + ".borrar" + master + "()}");
	        args.put("guardardetalle", "#{bean" + detalle + ".crear" + detalle + "()}");
	        args.put("borrardetalle", "#{bean" + detalle + ".borrar" + detalle + "()}");
			IContainer container = (IContainer) resource;
			final IFile file = container.getFile(new Path(fileName + ".xhtml"));
			try {
				InputStream stream = openContentStream();
				if (file.exists()) {
				} else {
					Writer filef = new FileWriter(root.getRawLocation().toString() + containerName + "/"  + fileName + ".xhtml");
					Configuration cfg = new Configuration(Configuration.VERSION_2_3_23);
					cfg.setClassForTemplateLoading(getClass(), "/res/");
					cfg.setDefaultEncoding("UTF-8");
					cfg.setLogTemplateExceptions(false);
					Template template = cfg.getTemplate("MASTERDETAIL.ftl");
					template.process(args, filef);
				}
				stream.close();
				} catch (IOException e) {
					MessageBox dialog =
						    new MessageBox(getShell(), SWT.ICON_QUESTION | SWT.OK| SWT.CANCEL);
					System.out.println(e.getMessage());
					System.out.println(e.getCause());
				}

			} catch (Exception e) {
				System.out.println(e.getMessage());
				System.out.println(e.getCause());
			}
	}
	
	/**
	 * We will initialize file contents with a sample text.
	 */

	private InputStream openContentStream() {
		String contents =
			"This is the initial file contents for *.xhtml file that should be word-sorted in the Preview page of the multi-page editor";
		return new ByteArrayInputStream(contents.getBytes());
	}

	private void throwCoreException(String message) throws CoreException {
		IStatus status =
			new Status(IStatus.ERROR, "PFPlantillas", IStatus.OK, message, null);
		throw new CoreException(status);
	}

	/**
	 * We will accept the selection in the workbench to see if
	 * we can initialize from it.
	 * @see IWorkbenchWizard#init(IWorkbench, IStructuredSelection)
	 */
	@Override
	public void init(IWorkbench workbench, IStructuredSelection selection) {
		this.selection = selection;
	}
}