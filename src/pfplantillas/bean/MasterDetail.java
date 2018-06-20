package pfplantillas.bean;

import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.jface.wizard.Wizard;
import org.eclipse.ui.INewWizard;
import org.eclipse.ui.IWorkbench;
import org.osgi.framework.Bundle;
import org.eclipse.core.runtime.*;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.operation.IRunnableWithProgress;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.core.resources.*;

import java.awt.Toolkit;
import java.io.*;
import java.lang.reflect.InvocationTargetException;
import java.net.URISyntaxException;
import java.net.URL;

import org.eclipse.jface.wizard.WizardPage;
import org.eclipse.ui.*;

import freemarker.cache.ClassTemplateLoader;
import freemarker.cache.FileTemplateLoader;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.cache.TemplateLoader;

/**
 * This is a sample new wizard. Its role is to create a new file resource in the
 * provided container. If the container resource (a folder or a project) is
 * selected in the workspace when the wizard is opened, it will accept it as the
 * target container. The wizard creates one file with the extension "mpe". If a
 * sample multi-page editor (also available as a template) is registered for the
 * same extension, it will be able to open it.
 */

public class MasterDetail extends Wizard implements INewWizard {
	private MasterDetailPage page;
	private ISelection selection;

	/**
	 * Constructor for SampleNewWizard.
	 */
	public MasterDetail() {
		super();
		setNeedsProgressMonitor(true);
	}

	/**
	 * Adding the page to the wizard.
	 */

	public void addPages() {
		page = new MasterDetailPage(selection);
		addPage(page);
	}

	/**
	 * This method is called when 'Finish' button is pressed in the wizard. We will
	 * create an operation and run it using wizard as execution context.
	 */
	public boolean performFinish() {
		final String containerName = page.getContainerName();
		final String HtmlTitle = page.getTitle();
		final String master = page.getMaestroText().getText();
		final String detalle = page.getDetalleText().getText();
		IRunnableWithProgress op = new IRunnableWithProgress() {
			public void run(IProgressMonitor monitor) {
				try {
					doFinish(containerName, HtmlTitle, master, detalle, monitor);
				} catch (CoreException e) {
//					throw new InvocationTargetException(e);
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
	 * The worker method. It will find the container, create the file if missing or
	 * just replace its contents, and open the editor on the newly created file.
	 */

	private void doFinish(String containerName,
			String HtmlTitle,
			String master,
			String detalle,
			IProgressMonitor monitor
			) throws CoreException {
		IWorkspaceRoot root = ResourcesPlugin.getWorkspace().getRoot();
		IResource resource = root.findMember(new Path(containerName));
		if (!resource.exists() || !(resource instanceof IContainer)) {
			throwCoreException("Container \"" + containerName + "\" does not exist.");
		}

		try {
			Map<String, String> args = new HashMap<String, String>();
			if (containerName.indexOf("src/main/java/") !=-1) {
				String empaque = containerName.substring(containerName.indexOf("src/")+14).replace("/", ".");
				args.put("package", empaque);
			}

			args.put("loginBean", "#{loginBean}");
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
			final IFile file = container.getFile(new Path("/Bean"  + detalle + ".java"));
			try {
				InputStream stream = openContentStream();
				if (file.exists()) {
				} else {
					Writer filef = new FileWriter(root.getRawLocation().toString() + containerName + "/Bean"  + detalle + ".java");
					Configuration cfg = new Configuration(Configuration.VERSION_2_3_23);
					cfg.setClassForTemplateLoading(getClass(), "/res/");
					cfg.setDefaultEncoding("UTF-8");
					cfg.setLogTemplateExceptions(false);
					Template template = cfg.getTemplate("beanMASTERDETAIL.ftl");
					template.process(args, filef);
				}
				stream.close();
			} catch (IOException e) {
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
		String contents = "This is the initial file contents for *.mpe file that should be word-sorted in the Preview page of the multi-page editor";
		return new ByteArrayInputStream(contents.getBytes());
	}

	private void throwCoreException(String message) throws CoreException {
		IStatus status = new Status(IStatus.ERROR, "PrimefacesCrud", IStatus.OK, message, null);
		throw new CoreException(status);
	}

	/**
	 * We will accept the selection in the workbench to see if we can initialize
	 * from it.
	 * 
	 * @see IWorkbenchWizard#init(IWorkbench, IStructuredSelection)
	 */
	public void init(IWorkbench workbench, IStructuredSelection selection) {
		this.selection = selection;
	}

}