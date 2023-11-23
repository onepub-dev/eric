part of 'internal_parts.dart';

/// represents a dependency that has a 'path' key
/// A path dependency is located on the local file
/// system. The path is a relative or absolute path
/// to the dependant package.
/// A path dependency takes the form of:
/// dependencies:
///   dcli:
///     path: ../dcli
class DependencyPath implements Dependency {
  /// Creates Path dependency from an existing [Line] in
  /// the document.
  DependencyPath._fromLine(this._dependencies, this._line)
      : _section = Section.fromLine(_line) {
    _name = _line.key;
    _pathLine = _line.findRequiredKeyChild('path');
    path = _pathLine.value;
  }

  /// Creates a  Path Dependency inserting it into the document after
  /// [lineBefore]
  DependencyPath._insertAfter(
      PubSpec pubspec, Line lineBefore, DependencyPathBuilder dependency) {
    _name = dependency.name;
    path = dependency.path;

    _line = Line.forInsertion(pubspec.document, '  $_name:');
    pubspec.document.insertAfter(_line, lineBefore);
    _section = Section.fromLine(_line);

    _pathLine =
        Line.forInsertion(pubspec.document, '${_line.childIndent}path: $path');
    pubspec.document.insertAfter(_pathLine, _line);

    // // ignore: prefer_foreach
    // for (final comment in dependency.comments) {
    //   comments.append(comment);
    // }
  }
  static const key = 'path';

  late final Section _section;
  late final String _name;
  late final String path;

  /// The parent dependency key
  late final Dependencies _dependencies;

  /// Line that contained the dependency declaration
  late final Line _line;
  late final Line _pathLine;

  @override
  String get name => _name;

  /// Allows cascading calls to append
  @override
  Dependency append(DependencyBuilder dependency) {
    _dependencies.append(dependency);
    return this;
  }

  @override
  String toString() => _section.lines.join('\n');
}
