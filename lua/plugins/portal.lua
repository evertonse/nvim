-- TODO: Test this, maybe is the solution to the jumplist on current buffer only
-- it lists both harpoon and grapple which are both interesting
-- Another thing to consider is that harpoon is getting a sequel (2)
return {
  'cbochs/portal.nvim',
  lazy = false,
  enabled = false,
  -- Optional dependencies
  dependencies = {
    'cbochs/grapple.nvim',
    'ThePrimeagen/harpoon',
  },
}
