module.exports = function (grunt) {
    grunt.initConfig({
        ngAnnotate: {
            options: {
                singleQuotes: true
            },
            build: {
                files: [{
                    expand: true,
                    src: '**/*.js',
                    dest: 'public/tmp/js',
                    cwd: 'public/js'
                }]
            }
        },
        uglify: {
            build: {
                files: [{
                    expand: true,
                    src: '**/*.js',
                    dest: 'public',
                    cwd: 'public/tmp'
                }]
            }
        },
        eslint: {
            target: ['app.js', 'services/*.js','routes/*.js','utils/*.js','workers/*.js','public/js/**/*.js', '!public/js/utils/*.js']
        }
    });
    // cwd : CURRENT WORKING DIRECTORY
    // load plugins
    grunt.loadNpmTasks('grunt-ng-annotate');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks("grunt-eslint");

    // register at least this one task
    grunt.registerTask('default', ['ngAnnotate', 'uglify', 'eslint']);
};