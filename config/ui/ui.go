package main

import (
	"fmt"
	"io"
	"os"

	"github.com/gdamore/tcell/v2"
	"github.com/rivo/tview"
)

// // VARIABLES // //
var app *tview.Application
var err error
var packageName string
var debian string
var dependencyName string
var commandDistros string

var txtIntro string
var bodyIntro *tview.TextView
var footerIntro *tview.TextView
var pageIntro *tview.Flex

var headerName *tview.TextView
var bodyName *tview.InputField
var footerName *tview.TextView
var pageName *tview.Flex

var txtDependenciesIntro string
var bodyDependenciesIntro *tview.Form
var footerDependenciesIntro *tview.TextView
var pageDependenciesIntro *tview.Flex

var headerDependenciesAdd *tview.TextView
var bodyDependenciesAdd *tview.Form
var pageDependenciesAdd *tview.Flex
var footerDependenciesAdd *tview.TextView

var pages *tview.Pages

// // FUNCTIONS // //
// check if there already exists a file "pkgfile" in the working directory.
// If don't, create it.
func createCfile() {
	_, err := os.Stat("cfile")
	if err == nil {
		app.Stop()
		fmt.Println("ERROR. There already exists a cfile in the working directory.")
	} else {
		file, err := os.OpenFile("cfile", os.O_WRONLY|os.O_APPEND|os.O_CREATE, 0644)
		if err != nil {
			panic(err)
		}
		defer file.Close()
		shellHeader := []byte("#! /bin/bash \n\n")
		file.Write(shellHeader)
	}
}

// create the file "cfile_standard" where the bidimensional array
// of source and target files will be built.
// If it already exists, delete it first.
func createCfileStandard() {
	_, err := os.Stat("pkgfile_dependencies_distros")
	if err == nil {
		os.Remove("pkgfile_dependencies_distros")
		if err != nil {
			panic(err)
		}
	} else {
		file, err := os.OpenFile("pkgfile_dependencies_distros", os.O_WRONLY|os.O_APPEND|os.O_CREATE, 0644)
		if err != nil {
			panic(err)
		}
		defer file.Close()
		dependenciesDistroArray := []byte("declare -A PKG_distro_package_name\n\n")
		file.Write(dependenciesDistroArray)
	}
}

// append the "cfile_standard" with the declaration statements in the standard mode
func declarationsCfileStandard {
	file, err := os.OpenFile("cfile_standard", os.O_WRONLY|os.O_APPEND|os.O_CREATE, 0644)
		if err != nil {
			panic(err)
		}
	defer file.Close()

	declarationsTxt := `
declare -A SYNC_blocks
declare -A SYNC_source
declare -A SYNC_target
declare -A SYNC_alias
declare -A SYNC_cmd_before
declare -A SYNC_cmd_after

declare -A SYNC_max
declare -A SYNC_max_cmd_before
declare -A SYNC_max_cmd_after
`
	declarationsByte := []byte(declarationsTxt)
	file.Write(declarationsByte)
}


// append "pkgfile_dependencies_distros" with the command of the package in the distros:

func appendDependenciesDistrosPkgfile(name, command string) {
	file, err := os.OpenFile("pkgfile_dependencies_distros", os.O_WRONLY|os.O_APPEND|os.O_CREATE, 0644)
	if err != nil {
		panic(err)
	}
	defer file.Close()

	var commandDistros string

	for _, distro := range distros {
		commandDistros = commandDistros +
			"PKG_distro_package_name[\"" + distro + "\",\"" + name + "\"]=\"" + command + "\"\n"
	}

	commandByte := []byte(commandDistros)
	file.Write(commandByte)
}

// create a form of the dependencies names and commands in distros.
// print the result in the files "pkgfile_dependencies" and "pkgfile_dependencies_distros".
func addFilesPair() {

	var labels []string

	labels = append(labels, "source file path:")
	labels = append(labels, "target file path:")
	labels = append(labels, "pair alias:")	

	for i := 0; i < len(labels); i++ {
		bodyStandardFilesAdd.AddInputField(labels[i], "", 30, nil, nil).
			SetFieldBackgroundColor(tcell.ColorGray).
			SetFieldTextColor(tcell.ColorWhite).
			SetLabelColor(tcell.ColorWhite)
	}

	bodyStandardFilesAdd.AddButton("add other", func() {
		sourceFile = bodyStandardFilesAdd.GetFormItemByLabel(labels[0]).(*tview.InputField).GetText()
		targetFile = bodyStandardFilesAdd.GetFormItemByLabel(labels[1]).(*tview.InputField).GetText()
		aliasFile = bodyStandardFilesAdd.GetFormItemByLabel(labels[2]).(*tview.InputField).GetText()

		appendDependenciesPkgfile(dependencyName)
		appendDependenciesDistrosPkgfile(dependencyName, commandDistros)

		pages.SwitchToPage("Standard Files Intro")
	}).
		SetLabelColor(tcell.ColorWhite).
		SetBorder(false)


	bodyStandardFilesAdd.AddButton("add command before", func() {
		sourceFile = bodyStandardFilesAdd.GetFormItemByLabel(labels[0]).(*tview.InputField).GetText()
		targetFile = bodyStandardFilesAdd.GetFormItemByLabel(labels[1]).(*tview.InputField).GetText()
		aliasFile = bodyStandardFilesAdd.GetFormItemByLabel(labels[2]).(*tview.InputField).GetText()

		appendDependenciesPkgfile(dependencyName)
		appendDependenciesDistrosPkgfile(dependencyName, commandDistros)

		pages.SwitchToPage("Command Before Files Add")
	}).
		SetLabelColor(tcell.ColorWhite).
		SetBorder(false)
	
	bodyStandardFilesAdd.AddButton("add command after", func() {
		sourceFile = bodyStandardFilesAdd.GetFormItemByLabel(labels[0]).(*tview.InputField).GetText()
		targetFile = bodyStandardFilesAdd.GetFormItemByLabel(labels[1]).(*tview.InputField).GetText()
		aliasFile = bodyStandardFilesAdd.GetFormItemByLabel(labels[2]).(*tview.InputField).GetText()

		appendDependenciesPkgfile(dependencyName)
		appendDependenciesDistrosPkgfile(dependencyName, commandDistros)

		pages.SwitchToPage("Command Before Files Add")
	}).
		SetLabelColor(tcell.ColorWhite).
		SetBorder(false)

	bodyStandardFilesAdd.AddButton("add exclude", func() {
		sourceFile = bodyStandardFilesAdd.GetFormItemByLabel(labels[0]).(*tview.InputField).GetText()
		targetFile = bodyStandardFilesAdd.GetFormItemByLabel(labels[1]).(*tview.InputField).GetText()
		aliasFile = bodyStandardFilesAdd.GetFormItemByLabel(labels[2]).(*tview.InputField).GetText()

		appendDependenciesPkgfile(dependencyName)
		appendDependenciesDistrosPkgfile(dependencyName, commandDistros)

		pages.SwitchToPage("Exclude Files Add")
	}).
		SetLabelColor(tcell.ColorWhite).
		SetBorder(false)

	bodyDependenciesAdd.AddButton("return", func() {
		pages.SwitchToPage("Standard Intro")

			}).
		SetLabelColor(tcell.ColorWhite).
		SetBorder(false)
}

// function to pass when the conclude button is pressed.
// append the file "pkgfile" with the other files.
// move the "pkgfile" to the working directory
func concludePkgfile() {
	var pkgfiles = []string{
		"pkgfile_distros",
		"pkgfile_dependencies",
		"pkgfile_dependencies_distros",
	}
	var pkgfile string = "pkgfile"

	target, err := os.OpenFile(pkgfile, os.O_APPEND|os.O_WRONLY, 0644)
	if err != nil {
		panic(err)
	}

	defer target.Close()
	if err != nil {
		panic(err)
	}

	for _, file := range pkgfiles {
		source, err := os.Open(file)
		if err != nil {
			panic(err)
		}
		_, err = io.Copy(target, source)
		if err != nil {
			panic(err)
		}

		newLine := []byte("\n\n")
		_, err = target.Write(newLine)
		if err != nil {
			panic(err)
		}

		err = source.Close()
		if err != nil {
			panic(err)
		}
	}
}

// delete just the additional files.
// used when concluding the configuration
func deleteConcludePkgfile() {
	os.Remove("pkgfile_distros")
	if err != nil {
		panic(err)
	}

	_, err := os.Stat("pkgfile_dependencies")
	if err == nil {
		os.Remove("pkgfile_dependencies")
	} else {
		panic(err)
	}

	_, err = os.Stat("pkgfile_dependencies_distros")
	if err == nil {
		os.Remove("pkgfile_dependencies_distros")
	} else {
		panic(err)
	}

}

// delete the additional files and the "pkgfile".
// used when exiting without concluding.

func deletePkgfile() {

	os.Remove("pkgfile")
	if err != nil {
		panic(err)
	}

	deleteConcludePkgfile()
}

// // MAIN // //
func main() {

	// initializing the app
	app = tview.NewApplication()

	// PAGE INTRO - text
	txtIntro = `
  Welcome to the configurarion mode of sync.sh.

  In the following you will create a cfile by providing:

	1. source and target files or dirs to be synchronized;
	2. commands to pass before and after the synchronization.
	3. patterns to be excluded during the synchronization.

  Optionally you will also configure the "git mode", designed to automate the syncronization
  between local directories and git initialized directories. In this case, for each pair of
  local-git directories, you will also provide:

	1. a default branch; 
	2. a default remote;
	3. a default commit,

  allowing the automation of a pull-push.
	`
	// PAGE INTRO - body
	bodyIntro = tview.NewTextView().
		SetText(txtIntro)

	// PAGE INTRO - footer
	footerIntro = tview.NewTextView().
		SetText(" (s) to init the standard mode\n (g) to init the git mode\n (esc) to quit\n (ctrl+c) to kill")

	// PAGE INTRO - building
	pageIntro = tview.NewFlex().SetDirection(tview.FlexRow).
		AddItem(bodyIntro, 0, 4, false).
		AddItem(footerIntro, 0, 1, false)

	// PAGE INTRO - keybind
	pageIntro.SetInputCapture(func(event *tcell.EventKey) *tcell.EventKey {
		if event.Rune() == 0 { // (esc)
			app.Stop()
			fmt.Println("Exiting config mode...")
		} else if event.Rune() == 115 { // (s)
			pages.SwitchToPage("Standard Intro")
		} else if event.Rune() == 103 { // (g)
			pages.SwitchToPage("Git Intro")
		}

		return event
	})
	
	// PAGE STANDARD INTRO - body
	txtStandardIntro = `
  You are in the "standard mode". Here, data is organized in blocks.

  A block will be constructed as collection of:

  1. dir-dir or file-file pairs
  2. commands to pass before and after the synchronization
  3. patterns to exclude.

  By default there is a block called "files", designed to file-file syncronization.
`
	bodyStandardIntro = tview.NewForm().
		AddTextView("", txtStandardIntro, 0, 10, true, true)

	// PAGE STANDARD INTRO - footer
	footerStandardIntro = tview.NewTextView().
		SetText(" (f) to edit the file-file block\n (d) to create a new dir-dir block\n (esc) to quit\n (ctrl+c) to kill")

	// PAGE STANDARD INTRO - building
	pageStandardIntro = tview.NewFlex().SetDirection(tview.FlexRow).
		AddItem(bodyDependenciesIntro, 0, 4, true).
		AddItem(footerDependenciesIntro, 0, 1, false)

	// PAGE STANDARD INTRO - keybind
	pageStandardIntro.SetInputCapture(func(event *tcell.EventKey) *tcell.EventKey {
		if event.Rune() == 0 { // (esc)
			deletePkgfile()
			app.Stop()
			fmt.Println("Exiting config mode...")
		} else if event.Rune() == 102 { // (f)
			pages.SwitchToPage("Standard Files Intro")
		} else if event.Rune() == 100 { // (d)
			pages.SwitchToPage("Standard Dirs Intro")
		}

		return event
	})

	// PAGE STANDARD FILES INTRO - body
	txtStandardFilesIntro = `
  In the following you will edit the files block.

    1. Hit (a) to add a new file-file pair;
    2. if needed, add exclude patterns, before and after commands;
    3. act the button "add new" to add another file-file pair;
    4. repeat the process until added all file-file pairs;
    5. act the button "conclude".
`
	headerStandardFilesIntro = tview.NewTextView().
		SetText(txtStandardFilesIntro)

	// PAGE STANDARD FILES INTRO - footer
	footerStandardFilesIntro = tview.NewTextView().
		SetText(" (a) to add a file-file pair\n (esc) to quit\n (ctrl+c) to kill")
	
	// PAGE STANDARD FILES INTRO - building
	pageStandardFilesIntro = tview.NewFlex().SetDirection(tview.FlexRow).
		AddItem(bodyDependenciesIntro, 0, 4, true).
		AddItem(footerDependenciesIntro, 0, 1, false)

	// PAGE STANDARD INTRO - keybind
	pageStandardFilesIntro.SetInputCapture(func(event *tcell.EventKey) *tcell.EventKey {
		if event.Rune() == 0 { // (esc)
			deletePkgfile()
			app.Stop()
			fmt.Println("Exiting config mode...")
		} else if event.Rune() == 97 { // (a)
			bodyStandardFilesAdd.Clear(true)
			addFilesPair()
			pages.SwitchToPage("Standard Files Add")
		}
		return event
	})

	// PAGE STANDARD FILES ADD - header
	headerStandardFilesAdd = tview.NewTextView().
		SetText("\n  Enter the full path to the source/target files and an alias to this pair...")

	// PAGE STANDARD FILES ADD - body
	bodyStandardFilesAdd = tview.NewForm()

	// PAGE STANDARD FILES ADD - footer
	footerStandardFilesAdd = tview.NewTextView().
		SetText(" (ctrl+c) to kill")

	// PAGE STANDARD FILES ADD - building
	pageStandardFilesAdd = tview.NewFlex().SetDirection(tview.FlexRow).
		AddItem(headerStandardFilesAdd, 0, 1, false).
		AddItem(bodyStandardFilesAdd, 0, 4, true).
		AddItem(footerStandardFilesAdd, 0, 1, false)

	

	// PAGES
	pages = tview.NewPages().
		AddPage("Intro", pageIntro, true, true).
		AddPage("Standard Intro", pageStandardIntro, true, false).
		AddPage("Standard Files Intro", pageStandardFilesIntro, true, false).
		AddPage("Standard Files Add", pageStandardFilesAdd, true, false).
		AddPage("Standard Dirs Intro", pageStandardDirsIntro, true, false).
		AddPage("Standard Dirs Block Add", pageStandardDirsBlockAdd, true, false).
		AddPage("Standard Dirs Add", pageStandardDirsAdd, true, false).
		AddPage("Git Intro", pageGitIntro, true, false).
		AddPage("Git Parent Add", pageGitParentAdd, true, false).
		AddPage("Git Add", pageGitAdd, true, false).
		AddPage("Exclude Add", pageExcludeAdd, true, false).
		AddPage("Command Before Add", pageCommandBeforeAdd, true, false).
		AddPage("Command After Add", pageCommandAfterAdd, true, false)

	// setting the widget "pages" as the root. Enable mouse.
	if err := app.SetRoot(pages, true).EnableMouse(true).Run(); err != nil {
		panic(err)
	}

}
