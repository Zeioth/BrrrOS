from ranger.api.commands import Command
import os
from ranger.core.loader import CommandLoader


class paste_as_root(Command):
    def execute(self):
        if self.fm.do_cut:
            self.fm.execute_console('shell sudo mv %c .')
        else:
            self.fm.execute_console('shell sudo cp -r %c .')


# FZF METHODS
# =============================================================================
class fzf_files(Command):
    """
    :fzf_files

    Find a file using fzf.

    See: https://github.com/junegunn/fzf
    """

    def execute(self):
        import subprocess
        import os.path
        # match normal and hidden files excluding the heavy ones
        command = ("fd --type f --hidden --exclude .git "
                   "--exclude node_modules --exclude .cache --exclude .npm "
                   "--exclude .mozilla --exclude .meteor --exclude .nv "
                   "--exclude .thunderbird --exclude .cargo | fzf +m "
                   "--reverse --header='Jump to filemap <C-t> fzf_files'")

        # Original command - (Match files and directories)
        # command="find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune \
        # -o -print 2> /dev/null | sed 1d | cut -b3- | fzf +m --reverse --header='Jump to filemap <C-f> fzf_select'"

        # The actual function
        fzf = self.fm.execute_command(command, universal_newlines=True,
                                      stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.rstrip('\n'))
            if os.path.isdir(fzf_file):
                exec('try:self.fm.cd(fzf_file)\nexcept:pass')
            else:
                exec('try:self.fm.select_file(fzf_file)\nexcept:pass')


class fzf_cd(Command):
    """
    :fzf_cd

    Find a directory using fzf.

    See: https://github.com/junegunn/fzf
    """

    def execute(self):
        import subprocess
        import os.path
        # match normal and hidden files excluding the heavy ones
        command = ("fd --type d --hidden --exclude .git "
                   "--exclude node_modules --exclude .cache --exclude .npm "
                   "--exclude .mozilla --exclude .meteor --exclude .nv "
                   "--exclude .thunderbird --exclude .cargo | fzf +m "
                   "--reverse --header='Jump to filemap <A-c> fzf_cd'")

        # The actual function
        fzf = self.fm.execute_command(command, universal_newlines=True,
                                      stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.rstrip('\n'))
            if os.path.isdir(fzf_file):
                exec('try:self.fm.cd(fzf_file)\nexcept:pass')
            else:
                self.fm.select_file(fzf_file)

# ZIP METHODS - TODO: Refactor them all in 1 method that take 1 param.
# =============================================================================


class uncompress_here(Command):
    def execute(self):
        """ Extract selected files to current directory."""
        import os
        from ranger.core.loader import CommandLoader
        cwd = self.fm.thisdir
        copied_files = tuple(cwd.get_selection())

        def refresh(_):
            cwd = self.fm.get_directory(original_path)
            cwd.load_content()

        one_file = copied_files[0]
        cwd = self.fm.thisdir
        original_path = cwd.path
        au_flags = ['-X', cwd.path]
        au_flags += self.line.split()[1:]
        au_flags += ['-e']

        self.fm.copy_buffer.clear()
        self.fm.cut_buffer = False
        if len(copied_files) == 1:
            descr = "extracting: " + os.path.basename(one_file.path)
        else:
            descr = "extracting files from: " + os.path.basename(
                one_file.dirname)
        obj = CommandLoader(args=['aunpack'] + au_flags
                            + [f.path for f in copied_files], descr=descr,
                            read=True)

        obj.signal_bind('after', refresh)
        self.fm.loader.add(obj)


class uncompress_subdirectory(Command):
    def execute(self):
        """ Extract selected files to current directory under ./tmp_uncompressed
        """
        try:
            os.mkdir("./tmp_extracted")
        except OSError:
            print("Creation of the directory './tmp_extracted' has failed.")

        cwd = self.fm.thisdir
        copied_files = tuple(cwd.get_selection())

        def refresh(_):
            cwd = self.fm.get_directory(original_path)
            cwd.load_content()

        one_file = copied_files[0]
        cwd = self.fm.thisdir
        original_path = cwd.path
        au_flags = ['-X', cwd.path+"/tmp_extracted"]
        au_flags += self.line.split()[1:]
        au_flags += ['-e']

        self.fm.copy_buffer.clear()
        self.fm.cut_buffer = False
        if len(copied_files) == 1:
            descr = "extracting: " + os.path.basename(one_file.path)
        else:
            descr = "extracting files from: " + os.path.basename(
                one_file.dirname)
        obj = CommandLoader(args=['aunpack'] + au_flags
                            + [f.path for f in copied_files], descr=descr,
                            read=True)

        obj.signal_bind('after', refresh)
        self.fm.loader.add(obj)


class uncompress_tmp(Command):
    def execute(self):
        """ Extract selected files to /tmp
        """
        try:
            os.mkdir("/tmp/tmp_extracted")
        except OSError:
            print("Creation of the directory '/tmp/tmp_extracted' has failed.")

        cwd = self.fm.thisdir
        copied_files = tuple(cwd.get_selection())

        def refresh(_):
            cwd = self.fm.get_directory(original_path)
            cwd.load_content()

        one_file = copied_files[0]
        cwd = self.fm.thisdir
        original_path = cwd.path
        au_flags = ['-X', "/tmp/tmp_extracted/"]
        au_flags += self.line.split()[1:]
        au_flags += ['-e']

        self.fm.copy_buffer.clear()
        self.fm.cut_buffer = False
        if len(copied_files) == 1:
            descr = "extracting: " + os.path.basename(one_file.path)
        else:
            descr = "extracting files from: " + os.path.basename(
                one_file.dirname)
        obj = CommandLoader(args=['aunpack'] + au_flags
                            + [f.path for f in copied_files], descr=descr,
                            read=True)

        obj.signal_bind('after', refresh)
        self.fm.loader.add(obj)


class compress_files_here(Command):
    def execute(self):
        """ Compress marked files to current directory. """
        cwd = self.fm.thisdir
        marked_files = cwd.get_selection()

        if not marked_files:
            return

        def refresh(_):
            cwd = self.fm.get_directory(original_path)
            cwd.load_content()

        original_path = cwd.path
        parts = self.line.split()
        au_flags = parts[1:]

        descr = "compressing files in: " + os.path.basename(parts[1])
        obj = CommandLoader(args=['apack'] + au_flags +
                            [os.path.relpath(
                                f.path, cwd.path) for f in marked_files],
                            descr=descr, read=True)

        obj.signal_bind('after', refresh)
        self.fm.loader.add(obj)

    def tab(self, tabnum):
        """ Complete with current folder name """

        extension = ['.zip', '.tar.gz', 'tar', '.rar', '.7z']
        return ['compress ' + os.path.basename(
            self.fm.thisdir.path) + ext for ext in extension]


class compress_files_tmp(Command):
    def execute(self):
        """ Compress marked files to the tmp directory. """
        cwd = "/tmp/"
        marked_files = cwd.get_selection()

        if not marked_files:
            return

        def refresh(_):
            cwd = self.fm.get_directory(original_path)
            cwd.load_content()

        original_path = cwd.path
        parts = self.line.split()
        au_flags = parts[1:]

        descr = "compressing files in: " + os.path.basename(parts[1])
        obj = CommandLoader(args=['apack'] + au_flags +
                            [os.path.relpath(
                                f.path, cwd.path) for f in marked_files],
                            descr=descr, read=True)

        obj.signal_bind('after', refresh)
        self.fm.loader.add(obj)

    def tab(self, tabnum):
        """ Complete with current folder name """

        extension = ['.zip', 'tar', '.tar.gz', '.rar', '.7z']
        return ['compress ' + os.path.basename(
            self.fm.thisdir.path) + ext for ext in extension]
