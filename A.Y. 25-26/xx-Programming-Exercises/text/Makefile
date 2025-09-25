# ==================================================================
# Universal LaTeX Makefile with Minted Support
# Always compiles main.tex regardless of document type
# ==================================================================
# Main document (always main.tex)
TARGET = main

# Source Paths
SRC_DIR = .
BIB_DIR = .
SECTION_DIR = .
OUTPUT_DIR = build
FIGURES_DIR = figures

# Program Definitions
# Using pdflatex with shell-escape for minted support
TEX = pdflatex -shell-escape -interaction=nonstopmode
# Alternative: use latexmk for more robust compilation
LATEXMK = latexmk -pdf -pdflatex="pdflatex -shell-escape -interaction=nonstopmode" 
BIBTEX = biber
MAKEINDEX = makeindex

# Minted Configuration
# Ensure pygmentize is available for minted syntax highlighting
MINTED_CHECK = $(shell which pygmentize 2>/dev/null)

# ==================================================================
# OS DETECTION AND COMMANDS
# ==================================================================

# OS detection
ifeq ($(OS),Windows_NT)
    ifneq ($(findstring .exe,$(SHELL)),)
        OS_TYPE := Windows
    else
        OS_TYPE := Cygwin
    endif
else
    OS_TYPE := $(shell uname -s)
endif

NOMENCL = nomencl.ist
RM = $(if $(filter $(OS_TYPE),Windows),del /f /q ,rm -f)
RMDIR = $(if $(filter $(OS_TYPE),Windows),rmdir /s /q ,rm -rf)

# Source Files
TEXSRC = $(wildcard $(SRC_DIR)/*.tex)
BIBSRC = $(wildcard $(BIB_DIR)/*.bib)
SECTIONSRC = $(wildcard $(SECTION_DIR)/*.tex)
FIGURESRC = $(wildcard $(FIGURES_DIR)/*)

# If the BIBSRC is not empty, then we need to generate the bbl database
ifneq ($(strip $(BIBSRC)),)
    BBLSRC = $(OUTPUT_DIR)/$(TARGET).bbl
endif

# ==================================================================
# TARGETS
# ==================================================================

# Default target
default: check-minted all

# Build main document
all: $(OUTPUT_DIR)/$(TARGET).pdf

# Quick build without checks
fast: $(OUTPUT_DIR)/$(TARGET).pdf

# Build with forced recompilation
force:
	@$(MAKE) clean
	@$(MAKE) all

# Check if minted dependencies are available
check-minted:
ifeq ($(MINTED_CHECK),)
	@echo "WARNING: pygmentize not found. Minted syntax highlighting may not work."
	@echo "Install pygments with: pip install pygments"
	@echo "Or on Ubuntu/Debian: sudo apt-get install python3-pygments"
	@echo "Or on macOS with Homebrew: brew install python3 && pip3 install pygments"
else
	@echo "Pygments found: $(MINTED_CHECK) - Minted will work correctly"
endif

# Create output directory
$(OUTPUT_DIR):
	@[ -d $(OUTPUT_DIR) ] || mkdir -p $(OUTPUT_DIR)
	@echo "Created build directory: $(OUTPUT_DIR)"

# Clean up auxiliary files (keeps PDF and important outputs)
clean:
	@echo "Cleaning auxiliary files..."
	-$(RM) $(OUTPUT_DIR)/*.aux $(OUTPUT_DIR)/*.log $(OUTPUT_DIR)/*.out \
	       $(OUTPUT_DIR)/*.toc $(OUTPUT_DIR)/*.lof $(OUTPUT_DIR)/*.lot \
	       $(OUTPUT_DIR)/*.fls $(OUTPUT_DIR)/*.fdb_latexmk \
	       $(OUTPUT_DIR)/*.synctex.gz $(OUTPUT_DIR)/*.nav \
	       $(OUTPUT_DIR)/*.snm $(OUTPUT_DIR)/*.vrb $(OUTPUT_DIR)/*.spl \
	       $(OUTPUT_DIR)/*.bcf $(OUTPUT_DIR)/*.blg $(OUTPUT_DIR)/*.xml \
	       $(OUTPUT_DIR)/*.nlo $(OUTPUT_DIR)/*.ilg $(OUTPUT_DIR)/*.nls \
	       $(OUTPUT_DIR)/*.figlist $(OUTPUT_DIR)/*.makefile \
	       $(OUTPUT_DIR)/*.pyg $(OUTPUT_DIR)/*.pytxcode
	-$(RMDIR) $(OUTPUT_DIR)/_minted-* 2>/dev/null || true
	@echo "Clean completed."

# Clean everything including PDFs
cleanall: clean
	@echo "Removing all generated files..."
	-$(RM) $(OUTPUT_DIR)/*.pdf $(OUTPUT_DIR)/*.bbl
	@echo "Deep clean completed."

# Remove output directory completely
distclean: cleanall
	-$(RMDIR) $(OUTPUT_DIR) 2>/dev/null || true
	@echo "Distribution clean completed."

# Open the generated PDF
open: $(OUTPUT_DIR)/$(TARGET).pdf
	@echo "Opening $(OUTPUT_DIR)/$(TARGET).pdf"
ifeq ($(OS_TYPE),Windows)
	@start "" "$(OUTPUT_DIR)/$(TARGET).pdf"
else ifeq ($(OS_TYPE),Cygwin)
	@cygstart $(OUTPUT_DIR)/$(TARGET).pdf
else ifeq ($(OS_TYPE),Darwin)
	@open $(OUTPUT_DIR)/$(TARGET).pdf
else
	@xdg-open $(OUTPUT_DIR)/$(TARGET).pdf 2>/dev/null &
endif

# Watch for changes and rebuild automatically (requires inotify-tools on Linux)
watch:
ifeq ($(OS_TYPE),Linux)
	@echo "Watching for changes in *.tex and figures/*... Press Ctrl+C to stop"
	@while true; do \
		inotifywait -q -e modify,create,delete *.tex $(FIGURES_DIR)/* 2>/dev/null && \
		echo "Files changed, rebuilding..." && \
		$(MAKE) fast; \
	done
else ifeq ($(OS_TYPE),Darwin)
	@echo "Watching for changes... Press Ctrl+C to stop"
	@echo "Note: Install fswatch for better file monitoring: brew install fswatch"
	@while true; do \
		sleep 2 && \
		if [ `find . -name "*.tex" -newer $(OUTPUT_DIR)/$(TARGET).pdf 2>/dev/null | wc -l` -gt 0 ] || \
		   [ `find $(FIGURES_DIR) -newer $(OUTPUT_DIR)/$(TARGET).pdf 2>/dev/null | wc -l` -gt 0 ]; then \
			echo "Files changed, rebuilding..." && \
			$(MAKE) fast; \
		fi; \
	done
else
	@echo "Watch mode only supported on Linux (with inotify-tools) and macOS"
endif

# Count pages, words, and other statistics
stats: $(OUTPUT_DIR)/$(TARGET).pdf
	@echo "=== Document Statistics ==="
	@echo "PDF file: $(OUTPUT_DIR)/$(TARGET).pdf"
	@if [ -f "$(OUTPUT_DIR)/$(TARGET).pdf" ]; then \
		echo "PDF pages: $$(pdfinfo $(OUTPUT_DIR)/$(TARGET).pdf 2>/dev/null | grep Pages | awk '{print $$2}' || echo 'Unable to determine')"; \
		echo "PDF size: $$(ls -lh $(OUTPUT_DIR)/$(TARGET).pdf | awk '{print $$5}')"; \
	else \
		echo "PDF not found - run 'make' first"; \
	fi
	@echo "TeX files: $$(find . -maxdepth 1 -name '*.tex' | wc -l)"
	@echo "Total lines in TeX files: $$(find . -maxdepth 1 -name '*.tex' -exec cat {} \; | wc -l)"
	@if [ -d "$(FIGURES_DIR)" ]; then \
		echo "Figures: $$(find $(FIGURES_DIR) -type f 2>/dev/null | wc -l || echo '0')"; \
	else \
		echo "Figures directory not found"; \
	fi

# Spell check (requires aspell)
spell:
	@echo "Spell checking main.tex..."
	@if command -v aspell >/dev/null 2>&1; then \
		aspell --mode=tex --check main.tex; \
	else \
		echo "aspell not found. Install with: apt-get install aspell (Linux) or brew install aspell (macOS)"; \
	fi

# Word count (approximate)
wordcount:
	@echo "Approximate word count:"
	@if command -v texcount >/dev/null 2>&1; then \
		texcount main.tex; \
	else \
		echo "texcount not available, using basic count:"; \
		cat main.tex | wc -w; \
		echo "(Note: install texcount for more accurate LaTeX word counting)"; \
	fi

# Help target
help:
	@echo "Available targets:"
	@echo "  all              - Build main.tex (default)"
	@echo "  fast             - Quick build without dependency checks"
	@echo "  force            - Clean and rebuild everything"
	@echo "  clean            - Remove auxiliary files"
	@echo "  cleanall         - Remove all generated files including PDF"
	@echo "  distclean        - Remove output directory completely"
	@echo "  open             - Open the generated PDF"
	@echo "  watch            - Watch files and rebuild automatically"
	@echo "  stats            - Show document statistics"
	@echo "  spell            - Spell check main.tex (requires aspell)"
	@echo "  wordcount        - Count words in main.tex"
	@echo "  check-minted     - Check minted dependencies"
	@echo "  help             - Show this help"
	@echo ""
	@echo "Document type detection:"
	@echo "  This Makefile automatically handles any type of LaTeX document"
	@echo "  including articles, reports, books, and Beamer presentations"
	@echo "  by always compiling main.tex in the current directory."

# ==================================================================
# COMPILATION RULES
# ==================================================================

# Main compilation rule using latexmk for robust handling
$(OUTPUT_DIR)/$(TARGET).pdf: $(TARGET).tex $(OUTPUT_DIR)
	@echo "======================== BUILDING DOCUMENT =========================="
	@echo "Compiling: $(TARGET).tex"
	@echo "Output directory: $(OUTPUT_DIR)"
	@if [ -f "$(TARGET).tex" ]; then \
		echo "Source file found: $(TARGET).tex"; \
	else \
		echo "ERROR: $(TARGET).tex not found in current directory"; \
		exit 1; \
	fi
	@$(LATEXMK) -output-directory=$(OUTPUT_DIR) $(TARGET).tex
ifeq ($(NOMENCLATURE),ON)
	@echo "Processing nomenclature..."
	@$(MAKEINDEX) $(OUTPUT_DIR)/$(TARGET).nlo -s $(NOMENCL) -o $(OUTPUT_DIR)/$(TARGET).nls
	@$(LATEXMK) -output-directory=$(OUTPUT_DIR) $(TARGET).tex
endif
	@echo "Build completed successfully: $(OUTPUT_DIR)/$(TARGET).pdf"
	@echo "=================================================================="

# Bibliography compilation (if needed)
$(OUTPUT_DIR)/$(TARGET).bbl: $(TEXSRC) $(BIBSRC) | $(OUTPUT_DIR)
	@echo "Processing bibliography..."
	@$(TEX) -output-directory=$(OUTPUT_DIR) $(TARGET).tex
	@$(BIBTEX) $(OUTPUT_DIR)/$(TARGET)

# ==================================================================
# PHONY TARGETS
# ==================================================================

.PHONY: default all fast force clean cleanall distclean open watch 
.PHONY: stats spell wordcount help check-minted

# ==================================================================
# AUTOMATIC VARIABLES INFO
# ==================================================================
# This Makefile uses several automatic variables:
# $@ - The target being made
# $< - The first prerequisite
# $^ - All prerequisites
# $? - All prerequisites newer than the target
# $(TARGET) - Always "main" - the base name of your tex file
# $(OUTPUT_DIR) - Always "build" - where compiled files go
