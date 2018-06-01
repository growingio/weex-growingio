# coding: utf-8

Pod::Spec.new do |s|
  s.name         = "WeexGrowingIO"
  s.version      = "0.1.0"
  s.summary      = "GrowingIO Weex Plugin"

  s.description  = <<-DESC
                   This Pod contains GrowingIO SDK plugin for weex. For more informations, please read https://github.com/growingio/weex-growingio
                   DESC

  s.homepage     = "https://www.growingio.com/"
  s.license = { type: 'MIT', text: <<-LICENSE
Copyright (c) 2015-2018 GrowingIO <support@growingio.com>
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
                       LICENSE
                   }
  s.authors      = {
                     'GrowingIO' => 'support@growingio.com'
                   }
  s.platform     = :ios
  s.ios.deployment_target = "7.0"

  s.source       = { :git => 'https://github.com/growingio/weex-growingio.git', :branch => 'develop'}
  s.source_files  = "ios/Sources/*.{h,m,mm}"
  
  s.requires_arc = true
  s.dependency "WeexPluginLoader"
  s.dependency "WeexSDK"
  s.dependency "GrowingCoreKit"

end
