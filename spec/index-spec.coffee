{WorkspaceView} = require 'atom'

describe "CSON Atom Plugin", ->
  [editor, editorView] = []

  cson2json = (callback) ->
    editorView.trigger "Convert:CSON to JSON"
    runs(callback)

  json2cson = (callback) ->
    editorView.trigger "Convert:JSON to CSON"
    runs(callback)

  beforeEach ->
    waitsForPromise -> atom.packages.activatePackage('cson')
    waitsForPromise -> atom.packages.activatePackage('language-json')

    atom.workspaceView = new WorkspaceView
    atom.workspaceView.openSync()

    editorView = atom.workspaceView.getActiveView()
    editor = editorView.getEditor()

  describe "JSON -> CSON", ->
    describe "when no text is selected", ->
      it "doesn't change anything", ->
        editor.setText """
          Start
          { "a": "b", "c": "d" }
          End
        """
        cson2json ->
          expect(editor.getText()).toBe """
            Start
            { "a": "b", "c": "d" }
            End
          """

    describe "when a valid json text is selected", ->
      it "converts it correctly", ->
        editor.setText """
          Start
          { "a": "b", "c": "d" }
          End
        """
        editor.setSelectedBufferRange([[1,0], [1, 22]])

        cson2json ->
          expect(editor.getText()).toBe """
            Start
            a: "b"
            c: "d"
            End
          """

    describe "when an invalid json text is selected", ->
      it "doesn't change anything", ->
        editor.setText """
          Start
          {]
          End
        """
        editor.setSelectedBufferRange([[1,0], [1, 2]])

        cson2json ->
          expect(editor.getText()).toBe """
            Start
            {]
            End
          """

    describe "JSON file", ->
      beforeEach ->
        editor.setGrammar(atom.syntax.selectGrammar('test.json'))

      describe "with invalid JSON", ->
        it "doesn't change anything", ->
          editor.setText """
            {]
          """

          cson2json ->
            expect(editor.getText()).toBe """
              {]
            """

      describe "with valid JSON", ->
        it "converts the whole file correctly", ->
          editor.setText """
            { "a": "b", "c": "d" }
          """

          cson2json ->
            expect(editor.getText()).toBe """
              a: "b"
              c: "d"
            """

      describe "Sort and prettify", ->
        beforeEach ->
          editor.setGrammar(atom.syntax.selectGrammar('test.json'))

        describe "with invalid JSON", ->
          it "doesn't change anything", ->
            editor.setText """
              {]
            """

            sortedPrettify ->
              expect(editor.getText()).toBe """
                {]
              """

        describe "with valid JSON", ->
          it "converts the whole file correctly", ->
            editor.setText """
              { "c": "d", "a": "b" }
            """

            sortedPrettify ->
              expect(editor.getText()).toBe """
                {
                  "a": "b",
                  "c": "d"
                }
              """

  describe "CSON -> JSON", ->
    describe "when no text is selected", ->
      it "doesn't change anything", ->
        editor.setText """
          Start
          { "a": "b", "c": "d" }
          End
        """
        json2cson ->
          expect(editor.getText()).toBe """
            Start
            { "a": "b", "c": "d" }
            End
          """

    describe "when a valid cson text is selected", ->
      it "converts it correctly", ->
        editor.setText """
          Start
          a: "b"
          c: "d"
          End
        """
        editor.setSelectedBufferRange([[1,0], [1, 22]])

        json2cson ->
          expect(editor.getText()).toBe """
            Start
            { "a": "b", "c": "d" }
            End
          """

    describe "when an invalid cson text is selected", ->
      it "doesn't change anything", ->
        editor.setText """
          Start
          {]
          End
        """
        editor.setSelectedBufferRange([[1,0], [1, 2]])

        json2cson ->
          expect(editor.getText()).toBe """
            Start
            {]
            End
          """

    describe "CSON file", ->
      beforeEach ->
        editor.setGrammar(atom.syntax.selectGrammar('test.json'))

      describe "with invalid CSON", ->
        it "doesn't change anything", ->
          editor.setText """
            {]
          """

          json2cson ->
            expect(editor.getText()).toBe """
              {]
            """

      describe "with valid CSON", ->
        it "converts the whole file correctly", ->
          editor.setText """
            a: "b"
            c: "d"
          """

          json2cson ->
            expect(editor.getText()).toBe """
              { "a": "b", "c": "d" }
            """
