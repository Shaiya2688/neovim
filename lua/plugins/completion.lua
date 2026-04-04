return {

  -- TODO: lsp, snippets, AI sources options
  -- Supports for autocompletion using multiple sources
  {
    "hrsh7th/nvim-cmp",
    -- See `:h cmp` for more help information
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local ok, cmp = pcall(require, 'cmp')
      if not ok then return end

      local select_fn = function(forward, behavior) -- popup completion menu or select/insert completion item
        if behavior ~= cmp.SelectBehavior.Select then
          behavior = cmp.SelectBehavior.Insert -- default bahavior
        end
        return function(fallback)
          local fn
          if cmp.visible() then
            if forward then
              fn = cmp.mapping.select_next_item({ behavior = behavior })
            else
              fn = cmp.mapping.select_prev_item({ behavior = behavior })
            end
          else
            fn = cmp.mapping.complete()
          end
          if type(fn) == 'function' then
            fn(fallback)
          else
            fallback()
          end
        end
      end

      -- Global setup.
      cmp.setup({
        completion = {
          autocomplete = { cmp.TriggerEvent.TextChanged },
          keyword_length = 2,
        },
        snippet = {
          expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)

            -- For `mini.snippets` users:
            -- local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
            -- insert({ body = args.body }) -- Insert at cursor
            -- cmp.resubscribe({ "TextChangedI", "TextChangedP" })
            -- require("cmp.config").set_onetime({ sources = {} })
          end,
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
        mapping = {
          ['<C-n>'] = select_fn(true, cmp.SelectBehavior.Insert), -- popup completion menu or insert next item
          ['<C-p>'] = select_fn(false, cmp.SelectBehavior.Insert), -- popup completion menu or insert prev item
          ['<DOWN>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), -- select next item
          ['<UP>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), -- select prev item
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- insert selected item
          ['<C-e>'] = cmp.mapping.abort(), -- closes the completion menu and restore inserted texts
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        },
        sources = cmp.config.sources({
          {
            name = 'buffer',
            option = { -- Using visible buffers to complete
              get_bufnrs = function()
                local bufs = {}
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                  bufs[vim.api.nvim_win_get_buf(win)] = true
                end
                return vim.tbl_keys(bufs)
              end,
            },
          },
          { name = 'nvim_lsp' },
          { name = 'path' },
          -- { name = 'vsnip' }, -- For vsnip users.
          -- { name = 'luasnip' }, -- For luasnip users.
          -- { name = 'snippy' }, -- For snippy users.
          -- { name = 'ultisnips' }, -- For ultisnips users.
        }, {
          -- {
          --   name = 'buffer',
          --   option = { -- Using visible buffers to complete
          --     get_bufnrs = function()
          --       local bufs = {}
          --       for _, win in ipairs(vim.api.nvim_list_wins()) do
          --         bufs[vim.api.nvim_win_get_buf(win)] = true
          --       end
          --       return vim.tbl_keys(bufs)
          --     end,
          --   },
          -- },
        })
      })

      -- `/` cmdline setup.
      -- FIXME: command mode key map cause <Tab> unworking under `:` cmdline, using key self to create one key mapping as a fallback key
      local mapself = function(keys)
        local keyself = function(key)
          k = vim.api.nvim_replace_termcodes(key, true, true, true)
          vim.api.nvim_feedkeys(k, "nt", false)
        end
        for _, key in ipairs(keys) do
          vim.keymap.set('c', key, function() keyself(key) end, { silent = false, } )
        end
      end
      mapself({ '<Tab>', '<S-Tab>', '<C-n>', '<C-p>', '<DOWN>', '<UP>', '<C-e>' })
      cmp.setup.cmdline('/', {
        completion = {
          autocomplete = false, -- Don't trigger autocompletion, only invoked by mapped key manually
        },
        mapping = {
          ['<Tab>'] = { -- popup completion menu or insert next item
            c = select_fn(true, cmp.SelectBehavior.Insert),
          },
          ['<S-Tab>'] = { -- popup completion menu or insert prev item
            c = select_fn(false, cmp.SelectBehavior.Insert),
          },
          ['<C-n>'] = { -- popup completion menu or insert next item
            c = select_fn(true, cmp.SelectBehavior.Insert),
          },
          ['<C-p>'] = { -- popup completion menu or insert prev item
            c = select_fn(false, cmp.SelectBehavior.Insert),
          },
          ['<DOWN>'] = { -- select and insert next item
            c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          },
          ['<UP>'] = { -- select and insert prev item
            c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          },
          ['<C-e>'] = { -- closes the completion menu and restore inserted texts
            c = cmp.mapping.abort(),
          },
        },
        sources = {
          { name = 'buffer' },
        },
      })

      -- Setup lspconfig.
      -- local capabilities = require('cmp_nvim_lsp').default_capabilities()
      -- require('lspconfig')[%YOUR_LSP_SERVER%].setup {
      --   capabilities = capabilities
      -- }

    end,
  },

}
