SimpleCov.start('rails') do
  add_group 'Units', 'app/models'
  add_group 'Functionals', 'app/controllers'
  add_group 'Services', 'app/services'
  add_group 'Libraries', 'lib/'

  add_filter '/test/'
  add_filter '/config/'
  add_filter '/db/'
  add_filter '/vendor/'
  add_filter '/log/'
  add_filter '/tmp/'
  add_filter '/node_modules/'
end
