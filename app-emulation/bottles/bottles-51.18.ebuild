# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit meson python-single-r1 xdg

DESCRIPTION="A graphical user interface to manage Wine prefixes"
HOMEPAGE="https://usebottles.com/"
SRC_URI="https://github.com/bottlesdevs/Bottles/archive/refs/tags/51.18.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
    >=gui-libs/gtk-4.10:4[introspection]
    >=gui-libs/libadwaita-1.2:1[introspection]
    dev-libs/json-glib
    dev-libs/libpeas
    app-crypt/libsecret
    x11-libs/libnotify
    dev-libs/libzip
    net-misc/curl
    >=gui-libs/gtksourceview-5.0:5
    >=dev-libs/libportal-0.6[introspection]
    x11-libs/cairo
    x11-libs/pango
    ${PYTHON_DEPS}
"
RDEPEND="${DEPEND}
    $(python_gen_cond_dep '
        app-arch/patool[${PYTHON_USEDEP}]
        dev-python/pycurl[${PYTHON_USEDEP}]
        dev-python/markdown[${PYTHON_USEDEP}]
        dev-python/fvs[${PYTHON_USEDEP}]
        dev-python/orjson[${PYTHON_USEDEP}]
        dev-python/chardet[${PYTHON_USEDEP}]
        dev-python/pathvalidate[${PYTHON_USEDEP}]
        dev-python/pyyaml[${PYTHON_USEDEP}]
        dev-python/requests[${PYTHON_USEDEP}]
        >=dev-python/pygobject-3.44:3[${PYTHON_USEDEP}]
    ')
    media-gfx/vkBasalt
    sys-apps/xdg-desktop-portal
    sys-apps/xdg-desktop-portal-gtk
    virtual/wine
"
BDEPEND="
    dev-build/meson
    dev-build/ninja
    dev-util/glib-utils
    >=gui-libs/gtk-4.10:4[introspection]
    dev-libs/gobject-introspection
"

S="${WORKDIR}/Bottles-51.18"

pkg_setup() {
    python-single-r1_pkg_setup
}

src_prepare() {
    default
    # Remove vkbasalt import and add stubs at the top
    sed -i '/from vkbasalt\.lib import parse, ParseConfig/d' "${S}/bottles/frontend/windows/vkbasalt.py" || die
    sed -i '1i\
# Stubbed vkbasalt functions for native build\n\
def parse(*args, **kwargs):\n\
    return None\n\
\n\
class ParseConfig:\n\
    pass\n\
' "${S}/bottles/frontend/windows/vkbasalt.py" || die
    # Replace @BASE_ID@ in frontend only
    find "${S}/bottles/frontend" -type f -name "*.py" -exec sed -i 's/@BASE_ID@/com.usebottles.bottles/g' {} + || die
    # Completely bypass sandbox check and dialog
    sed -i '/if not Xdp\.Portal\.running_under_sandbox():/,/return/c\        # Sandbox check bypassed for native execution\n        logging.info("Running natively, skipping sandbox check")' "${S}/bottles/frontend/windows/window.py" || die
    # Robustly set GLib app ID and log it
    sed -i 's/Gtk\.Application.__init__(self)/Gtk.Application.__init__(self, application_id="com.usebottles.bottles"); logging.info("Application ID set to com.usebottles.bottles")/' "${S}/bottles/frontend/windows/window.py" || die
    # Add debug log before quitting and bottle creation
    find "${S}/bottles/frontend" -type f -name "*.py" -exec sed -i 's/^\([[:space:]]*\)quit(/\1logging.info("Quitting application")\n\1quit(/g' {} + || die
    find "${S}/bottles/frontend" -type f -name "*.py" -exec sed -i 's/^\([[:space:]]*\)sys\.exit(/\1logging.info("Exiting via sys.exit")\n\1sys.exit(/g' {} + || die
    sed -i '/def create_bottle(self,/a\        logging.info("Starting bottle creation...")' "${S}/bottles/frontend/operation.py" || die
    sed -i '/self\.runner\.create_bottle/a\        logging.info("Bottle creation completed or failed")' "${S}/bottles/frontend/operation.py" || die
    # Patch Adw.WrapBox to Gtk.Box for older libadwaita compatibility
    sed -i 's/Adw\.WrapBox/Gtk\.Box/' "${S}/bottles/frontend/ui/bottle-row.blp" || die
    sed -i '/<object class="Gtk\.Box" id="wrap_box">/a\    <property name="orientation">horizontal</property>\n    <property name="spacing">6</property>' "${S}/bottles/frontend/ui/bottle-row.blp" || die
}

src_configure() {
    sed -i "s/error('file does not exist')/#error('file does not exist')/" "${S}/bottles/frontend/meson.build" || die
    meson setup "${S}" "${WORKDIR}/${P}-build" --prefix=/usr || die "Meson setup failed"
}

src_compile() {
    ninja -v -C "${WORKDIR}/${P}-build" || die "Ninja compile failed"
}

src_install() {
    meson install -C "${WORKDIR}/${P}-build" --destdir="${D}" || die "Meson install failed"
    dodir /usr/share/bottles/bottles
    einfo "Copying bottles directory contents to /usr/share/bottles/bottles/"
    cp -rv "${S}/bottles/"* "${D}/usr/share/bottles/bottles/" || die "Failed to copy bottles directory contents"
    python_optimize "${D}/usr/share/bottles/bottles"
    # Clean up any logging.info patches in the installed bottles script
    einfo "Cleaning /usr/bin/bottles of stray logging patches"
    sed -i '/logging\.info("Exiting via sys\.exit")/d' "${D}/usr/bin/bottles" || die "Failed to clean bottles script"
    sed -i '/logging\.info("Quitting application")/d' "${D}/usr/bin/bottles" || die "Failed to clean bottles script"
    python_fix_shebang "${D}/usr/bin/bottles"
    dodir /usr/share/glib-2.0/schemas
    einfo "Copying GSchema to /usr/share/glib-2.0/schemas/"
    cp -v "${S}/data/com.usebottles.bottles.gschema.xml" "${D}/usr/share/glib-2.0/schemas/" || die "Failed to copy GSchema"
    # Install icons without cache update in sandbox
    einfo "Installing icons to /usr/share/icons/hicolor/"
    cp -rv "${S}/data/icons/hicolor/"* "${D}/usr/share/icons/hicolor/" || die "Failed to copy icons"
}

pkg_postinst() {
    xdg_pkg_postinst
    einfo "Updating icon cache on live system..."
    gtk-update-icon-cache -f -t /usr/share/icons/hicolor || einfo "Failed to update icon cache - ensure gui-libs/gtk:4 is fully installed"
    einfo "Ensure your system's active Python version matches the one used by Bottles."
    einfo "Run 'eselect python list' to check, and 'eselect python set python3.12' if needed."
    einfo "Compiling GSettings schemas..."
    glib-compile-schemas /usr/share/glib-2.0/schemas/ || die "Schema compilation failed"
    einfo "For full functionality, ensure xdg-desktop-portal and xdg-desktop-portal-gtk are running."
    einfo "Start them with: 'systemctl --user start xdg-desktop-portal.service xdg-desktop-portal-gtk.service'"
    einfo "If bottle creation fails, check '~/.local/share/bottles/' permissions and terminal output."
}
