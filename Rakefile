## [ Mocks Generation ] ########################################################

task :mock do
    print_info "Generating mocks using local CLI version"
    sh "swift run swiftymocky generate"
end

## [ Tools ] ###################################################################

task :update do
    print_info "Re-Generating main template from parts"

    # Prepare SwiftyMocky template
    destination = "../Sources/SwiftyMocky/Mock.swifttemplate"
    sh "rm -rf #{destination}"
    sh "cd ./Templates && echo \"<%_\" > #{destination}"
    sh "cd ./Templates && echo 'let mockTypeName = \"Mock\"' >> #{destination}"
    sh "cd ./Templates && cat ArgumentsHelper.swift >> #{destination}"
    sh "cd ./Templates && echo \"_%>\" >> #{destination}"
    sh "cd ./Templates && cat Header.swifttemplate >> #{destination}"
    sh "cd ./Templates && cat Imports.swifttemplate >> #{destination}"
    sh "cd ./Templates && echo \"<%_\" >> #{destination}"
    sh "cd ./Templates && cat TemplateHelper.swift >> #{destination}"
    sh "cd ./Templates && cat Helpers.swift >> #{destination}"
    sh "cd ./Templates && cat ParameterWrapper.swift >> #{destination}"
    sh "cd ./Templates && cat TypeWrapper.swift >> #{destination}"
    sh "cd ./Templates && cat MethodWrapper.swift >> #{destination}"
    sh "cd ./Templates && cat SubscriptWrapper.swift >> #{destination}"
    sh "cd ./Templates && cat VariableWrapper.swift >> #{destination}"
    sh "cd ./Templates && echo \"_%>\" >> #{destination}"
    sh "cd ./Templates && cat Main.swifttemplate >> #{destination}"
end

task :test do
    # fast test for development
    sh "rake update"
    sh "rake mock"
    sh "ice test"
end

## [ Deploy ] ##################################################################

desc "Sets new version"
task :version do
    ARGV.each { |a| task a.to_sym do ; end }
    version_from = ARGV[1].to_s.strip
    version_to = ARGV[2].to_s.strip
    if version_from && !version_from.empty? && version_to && !version_to.empty?
        print_info "Changing version from #{version_from} -> #{version_to} !\n"
        sh("sed -i '' 's|#{version_from}|#{version_to}|g' ./.jazzy.yaml")
        sh("sed -i '' 's|#{version_from}|#{version_to}|g' ./README.md")
        sh("sed -i '' 's|#{version_from}|#{version_to}|g' ./guides/Installation.md")
        sh("sed -i '' 's|#{version_from}|#{version_to}|g' ./guides/Overview.md")
        sh("sed -i '' 's|#{version_from}|#{version_to}|g' ./SwiftyMocky-Runtime/Info.plist")
        sh("sed -i '' 's|#{version_from}|#{version_to}|g' ./Templates/Header.swifttemplate")
        sh("sed -i '' 's|#{version_from}|#{version_to}|g' ./Makefile")
        sh("sed -i '' 's|#{version_from}|#{version_to}|g' ./Sources/CLI/Core/Application.swift")
    else
        print("Missing versions!\n")
        exit(1)
    end
end

namespace :cli do
    desc "Assetizes templates for specified version of a SwiftyMocky into CLI"
    task :assetize do
        sh "swift run swiftymocky assetize"
    end

    task :build do
        print_info "Building CLI release version binary"
        # sh "swift build -c release --disable-sandbox"
        sh "swift build -c release"
        sh "cp ./.build/release/swiftymocky ./bin/swiftymocky"
    end
end

## [ Docs ] ####################################################################

desc "Update docs"
task :docs do
    print_info "Updating docs"
    sh "sourcekitten doc -- -workspace SwiftyMocky.xcworkspace -scheme SwiftyMocky > docs.json && jazzy --clean && rm docs.json"
end

## [ Helpers ] #################################################################

def print_info(str)
    (red,clr) = (`tput colors`.chomp.to_i >= 8) ? %W(\e[33m \e[m) : ["", ""]
    puts red, "== #{str.chomp} ==", clr
end
